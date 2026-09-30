// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_loader.dart';
import 'package:qration/core/utils/code_social_template.dart';
import 'package:qration/core/utils/code_type_conversion.dart';
import 'package:qration/core/utils/permission_helper.dart';
import 'package:qration/core/utils/rescan_guard.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:vibration/vibration.dart';

class ScannerScreen extends StatefulWidget {
  final bool isActive;

  const ScannerScreen({super.key, this.isActive = true});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _logger = Logger();
  final CodesRepository _codesService = Get.find<CodesRepository>();
  final _controller = MobileScannerController();
  final _picker = ImagePicker();
  final _audio = AudioPlayer();

  final _scanPrefs = Get.find<ScannerPreferencesController>();
  final _rescanGuard = RescanGuard();

  double _zoomLevel = 0;
  bool _permissionGranted = false;
  bool _permissionError = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await requestCameraPermission(context);
      if (mounted) setState(() => _permissionGranted = true);
    } catch (_) {
      if (mounted) setState(() => _permissionError = true);
    }
  }

  @override
  void didUpdateWidget(covariant ScannerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_permissionGranted || widget.isActive == oldWidget.isActive) return;
    if (widget.isActive) {
      _controller.start();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audio.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue;
    if (barcode == null || value == null || !_rescanGuard.accept(value)) {
      return;
    }

    if (mounted) setState(() => _isProcessing = true);

    try {
      if (_scanPrefs.beepEnabled) {
        await _audio.play(AssetSource('sounds/beep.mp3'));
      }
    } catch (e) {
      _logger.e('Error playing beep sound: $e');
    }
    try {
      if (_scanPrefs.vibrateEnabled && await Vibration.hasVibrator()) {
        await Vibration.vibrate();
      }
    } catch (e) {
      _logger.e('Error triggering vibration: $e');
    }

    try {
      await _processBarcode(value, barcode.type);
    } finally {
      // Start the rescan cooldown from the return to the scanner, not from
      // the original detection.
      _rescanGuard.touch();
      _isProcessing = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _processBarcode(String content, BarcodeType type) async {
    try {
      final CodeModel code;
      if (_isSocialUrl(content)) {
        code = createCodeSocialTemplate(content);
      } else {
        code = CodeModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          barcode: Barcode(rawValue: content, type: type),
          date: DateTime.now(),
          source: CodeSource.scanned,
        );
      }
      try {
        await _codesService.addCode(code).timeout(const Duration(seconds: 3));
      } on TimeoutException {
        // Firestore write is queued locally (offline persistence) but hasn't
        // been acknowledged by the server yet; don't block navigation on it.
      }
      // Stop the camera before pushing the details screen: with Impeller,
      // leaving the preview running underneath a pushed route while its
      // SurfaceTexture gets obscured can crash rendering with an
      // "Invalid external texture" error, leaving the screen stuck.
      try {
        await _controller.stop();
      } catch (e) {
        _logger.e('Error stopping camera before navigation: $e');
      }
      await Get.toNamed(AppRoutes.codeDetails, arguments: code);
      if (mounted && widget.isActive) {
        try {
          await _controller.start();
        } catch (e) {
          _logger.e('Error restarting camera after navigation: $e');
        }
      }
    } catch (e) {
      _logger.e('Error processing barcode: $e');
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!
              .code_scanner_screen_scan_qr_read_toast_error,
        );
      }
    }
  }

  bool _isSocialUrl(String content) =>
      content.startsWith('http') ||
      content.startsWith('https') ||
      content.startsWith('www.') ||
      content.startsWith('spotify:') ||
      content.startsWith('whatsapp://');

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    try {
      _logger.d('[scan-from-image] picked file: ${file.path}');
      final capture = await _controller.analyzeImage(file.path);
      _logger.d(
        '[scan-from-image] capture=${capture == null ? 'null' : 'non-null'}, '
        'barcodes=${capture?.barcodes.length ?? 0}',
      );
      final content = capture?.barcodes.firstOrNull?.rawValue;
      if (content != null) {
        final type = CodeTypeConversion.detectBarcodeType(content);
        await _processBarcode(content, type);
      } else {
        _logger.d('[scan-from-image] no barcode detected in picked image');
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!
                .code_scanner_screen_scan_qr_empty_toast_error,
          );
        }
      }
    } catch (e) {
      _logger.e('[scan-from-image] analyzeImage threw: $e');
      if (mounted) {
        showErrorToast(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(l10n.code_scanner_screen_title,
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(MingCuteIcons.mgc_photo_album_line,
                color: Colors.white),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: _permissionError
          ? Theme(
              data: ThemeData.dark(),
              child: AppErrorState(
                icon: Icons.videocam_off_outlined,
                title: l10n.code_scanner_screen_permission_error,
                onRetry: () {
                  setState(() => _permissionError = false);
                  _init();
                },
              ),
            )
          : !_permissionGranted
              ? const Center(child: AppLoader(color: Colors.white))
              : Stack(
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                    ),
                    // Scan overlay
                    _ScanOverlay(),
                    // Hint
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                MingCuteIcons.mgc_scan_fill,
                                color: AppColors.qrGold,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.code_scanner_screen_camera_hint,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Zoom slider
                    Positioned(
                      bottom: 120,
                      left: 40,
                      right: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: _ZoomSlider(
                          value: _zoomLevel,
                          onChanged: (v) {
                            setState(() => _zoomLevel = v);
                            _controller.setZoomScale(v);
                          },
                        ),
                      ),
                    ),
                    // Controls
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ControlButton(
                                icon: MingCuteIcons.mgc_flash_line,
                                onTap: _controller.toggleTorch,
                              ),
                              const SizedBox(width: 16),
                              _ControlButton(
                                icon: MingCuteIcons.mgc_refresh_2_line,
                                onTap: _controller.switchCamera,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Processing overlay: shown while a scanned code is being
                    // saved, so the ~1-3s Firestore round-trip (longer when
                    // offline, capped by the addCode timeout) doesn't read as
                    // a frozen screen.
                    if (_isProcessing)
                      Container(
                        color: Colors.black.withValues(alpha: 0.55),
                        child: const Center(
                          child: AppLoader(color: Colors.white),
                        ),
                      ),
                  ],
                ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 264,
            height: 264,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ),
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _CornerPainter(),
            ),
          ),
          Positioned(
            top: 130,
            left: 24,
            right: 24,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.qrGold,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.qrGold.withValues(alpha: 0.6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.scannerCorner
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;
    const r = 8.0;

    // Top-left
    canvas.drawArc(Rect.fromLTWH(0, 0, r * 2, r * 2), 3.14159, 0.5 * 3.14159,
        false, paint);
    canvas.drawLine(const Offset(0, r), Offset(0, cornerLen), paint);
    canvas.drawLine(const Offset(r, 0), Offset(cornerLen, 0), paint);

    // Top-right
    final tr = Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2);
    canvas.drawArc(tr, 1.5 * 3.14159, 0.5 * 3.14159, false, paint);
    canvas.drawLine(
        Offset(size.width, r), Offset(size.width, cornerLen), paint);
    canvas.drawLine(
        Offset(size.width - r, 0), Offset(size.width - cornerLen, 0), paint);

    // Bottom-left
    final bl = Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2);
    canvas.drawArc(bl, 0.5 * 3.14159, 0.5 * 3.14159, false, paint);
    canvas.drawLine(
        Offset(0, size.height - r), Offset(0, size.height - cornerLen), paint);
    canvas.drawLine(
        Offset(r, size.height), Offset(cornerLen, size.height), paint);

    // Bottom-right
    final br =
        Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2);
    canvas.drawArc(br, 0, 0.5 * 3.14159, false, paint);
    canvas.drawLine(Offset(size.width, size.height - r),
        Offset(size.width, size.height - cornerLen), paint);
    canvas.drawLine(Offset(size.width - r, size.height),
        Offset(size.width - cornerLen, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ZoomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _ZoomSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(MingCuteIcons.mgc_zoom_out_line,
            color: Colors.white, size: 18),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.qrGold,
              inactiveTrackColor: Colors.white30,
              thumbColor: AppColors.qrGold,
              overlayColor: AppColors.qrGold.withValues(alpha: 0.2),
              trackHeight: 2,
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ),
        const Icon(MingCuteIcons.mgc_zoom_in_line,
            color: Colors.white, size: 18),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}
