// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:flutter/services.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_loader.dart';
import 'package:qration/core/utils/code_type_conversion.dart';
import 'package:qration/core/utils/permission_helper.dart';
import 'package:qration/features/codes/controllers/scanner_controller.dart';

class ScannerScreen extends StatefulWidget {
  final bool isActive;

  const ScannerScreen({super.key, this.isActive = true});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _logger = Logger();
  final _controller = MobileScannerController();
  final _picker = ImagePicker();
  late final ScannerController _scanController;

  double _zoomLevel = 0;
  bool _permissionGranted = false;
  bool _permissionError = false;

  @override
  void initState() {
    super.initState();
    _scanController = Get.find<ScannerController>();
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
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue;
    if (barcode == null ||
        value == null ||
        !_scanController.tryBeginDetection(value)) {
      return;
    }

    await _scanController.playFeedback();
    try {
      await _processBarcode(value, barcode.type);
    } finally {
      _scanController.endDetection();
    }
  }

  Future<void> _processBarcode(String content, BarcodeType type) async {
    try {
      final code = await _scanController.saveScannedCode(content, type);
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
            tooltip: l10n.code_scanner_screen_tooltip_gallery,
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
                    _ScanOverlay(animate: widget.isActive),
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
                            borderRadius: BorderRadius.circular(AppRadius.pill),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white),
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
                          borderRadius: BorderRadius.circular(AppRadius.pill),
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
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder<MobileScannerState>(
                                valueListenable: _controller,
                                builder: (context, state, _) {
                                  final torch = state.torchState;
                                  final isOn = torch == TorchState.on;
                                  return _ControlButton(
                                    icon: isOn
                                        ? MingCuteIcons.mgc_flash_fill
                                        : MingCuteIcons.mgc_flash_line,
                                    tooltip: isOn
                                        ? l10n
                                            .code_scanner_screen_tooltip_torch_off
                                        : l10n
                                            .code_scanner_screen_tooltip_torch_on,
                                    highlighted: isOn,
                                    onTap: torch == TorchState.unavailable
                                        ? null
                                        : _controller.toggleTorch,
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _ControlButton(
                                icon: MingCuteIcons.mgc_refresh_2_line,
                                tooltip: l10n
                                    .code_scanner_screen_tooltip_switch_camera,
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
                    Obx(() => _scanController.isProcessing.value
                        ? Container(
                            color: Colors.black.withValues(alpha: 0.55),
                            child: const Center(
                              child: AppLoader(color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ),
    );
  }
}

class _ScanOverlay extends StatefulWidget {
  const _ScanOverlay({required this.animate});

  /// Runs the laser animation only while the scanner tab is visible.
  final bool animate;

  static const double windowSize = 264;
  static const double windowRadius = 24;

  @override
  State<_ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<_ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laser = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _laser.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _ScanOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate == oldWidget.animate) return;
    if (widget.animate) {
      _laser.repeat(reverse: true);
    } else {
      _laser.stop();
    }
  }

  @override
  void dispose() {
    _laser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = _ScanOverlay.windowSize;
    const laserInset = 20.0;
    final laserPosition = CurvedAnimation(
      parent: _laser,
      curve: Curves.easeInOut,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dims the camera preview outside the framing window.
        IgnorePointer(
          child: CustomPaint(
            painter: _ScrimPainter(
              windowSize: size,
              radius: _ScanOverlay.windowRadius,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(_ScanOverlay.windowRadius),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: CustomPaint(
                    size: const Size.square(size - 4),
                    painter: _CornerPainter(),
                  ),
                ),
                AnimatedBuilder(
                  animation: laserPosition,
                  builder: (context, child) => Positioned(
                    top: laserInset +
                        laserPosition.value * (size - 2 * laserInset),
                    left: 24,
                    right: 24,
                    child: child!,
                  ),
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
          ),
        ),
      ],
    );
  }
}

/// Paints [color] over the whole area except a centered rounded window.
class _ScrimPainter extends CustomPainter {
  _ScrimPainter({
    required this.windowSize,
    required this.radius,
    required this.color,
  });

  final double windowSize;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final window = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: windowSize,
        height: windowSize,
      ),
      Radius.circular(radius),
    );
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(window);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ScrimPainter oldDelegate) =>
      oldDelegate.windowSize != windowSize ||
      oldDelegate.radius != radius ||
      oldDelegate.color != color;
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
  final String tooltip;
  final VoidCallback? onTap;
  final bool highlighted;
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: highlighted
            ? AppColors.qrGold.withValues(alpha: 0.25)
            : Colors.white12,
        shape: CircleBorder(
          side: BorderSide(
            color: highlighted ? AppColors.qrGold : Colors.white30,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled
              ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
              : null,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              icon,
              color: enabled
                  ? (highlighted ? AppColors.qrGold : Colors.white)
                  : Colors.white38,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
