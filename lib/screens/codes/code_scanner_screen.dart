import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/screens/codes/code_details_screen.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/utils/code_social_template.dart';
import 'package:qration/utils/code_type_conversion.dart';
import 'package:qration/utils/permission_helper.dart';
import 'package:qration/widgets/custom_loader.dart';
import 'package:qration/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  var logger = Logger();
  bool _isCameraPermissionGranted = true;
  final CodesService _codesService = CodesService();
  Barcode? _barcode;
  String? _lastScannedBarcode;
  MobileScannerController cameraController = MobileScannerController();
  double _zoomLevel = 0.0;
  bool beepEnabled = false;
  bool vibrateEnabled = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  final ImagePicker _picker = ImagePicker();
  String? qrCodeContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: _isCameraPermissionGranted
            ? Center(child: _buildLoadingIndicator())
            : Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: _handleBarcode,
                  ),
                  const Center(child: QRInstructionWidget()),
                  Positioned(
                    bottom: 120.r,
                    left: 50.r,
                    right: 50.r,
                    child: ZoomSlider(
                      zoomLevel: _zoomLevel,
                      onZoomChanged: _onZoomChanged,
                    ),
                  ),
                  Positioned(
                    bottom: 50.r,
                    left: 0.r,
                    right: 0.r,
                    child: ActionButtons(
                      onToggleFlash: _toggleFlash,
                      onToggleCamera: _toggleCamera,
                      onPickImage: _pickImage,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    _loadPreferences();
  }

  Future<void> _checkCameraPermission() async {
    try {
      await requestCameraPermission(context);
      setState(() {
        _isCameraPermissionGranted = false;
      });
    } catch (e) {
      if (mounted) {
        Get.back();
      }
    }
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      beepEnabled = prefs.getBool('beepEnabled') ?? false;
      vibrateEnabled = prefs.getBool('vibrateEnabled') ?? false;
    });
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });

      logger.i(barcodes.barcodes.firstOrNull?.rawValue);

      if (_barcode != null && _barcode!.rawValue != _lastScannedBarcode) {
        _lastScannedBarcode = _barcode!.rawValue;
        logger.i(
            "Content scanned: ${_barcode!.rawValue} - ${DateTime.now().toIso8601String()}");

        if (beepEnabled) {
          await audioPlayer.play(AssetSource('sounds/beep.mp3'));
        }

        if (vibrateEnabled && (await Vibration.hasVibrator())) {
          Vibration.vibrate();
        }

        String content = _barcode!.rawValue ?? '';
        BarcodeType barcodeType = _barcode!.type;

        if ((content.startsWith('http') ||
                content.startsWith('https') ||
                content.startsWith('www.')) ||
            (content.startsWith('https://open.spotify.com/') ||
                content.startsWith('spotify:')) ||
            (content.startsWith('https://wa.me/') ||
                content.startsWith('whatsapp://'))) {
          final code = createCodeSocialTemplate(content);

          await _codesService.addCode(code);
          Get.off(
            () => CodeDetailsScreen(code: code),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          final scannedCode = CodeModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            barcode: Barcode(
              rawValue: content,
              type: barcodeType,
            ),
            date: DateTime.now(),
            source: CodeSource.scanned,
          );

          await _codesService.addCode(scannedCode);
          Get.off(
            () => CodeDetailsScreen(code: scannedCode),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    }
  }

  void _onZoomChanged(double value) {
    setState(() {
      _zoomLevel = value;
      cameraController.setZoomScale(_zoomLevel);
    });
  }

  void _toggleFlash() {
    cameraController.toggleTorch();
  }

  void _toggleCamera() {
    cameraController.switchCamera();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _scanQRCode(imageFile);
    }
  }

  Future<void> _scanQRCode(File imageFile) async {
    try {
      final BarcodeCapture? qrCodeCapture =
          await cameraController.analyzeImage(imageFile.path);
      final String? qrCodeContent =
          qrCodeCapture?.barcodes.firstOrNull?.rawValue;

      if (qrCodeContent != null) {
        final barcodeType = CodeTypeConversion.detectBarcodeType(qrCodeContent);
        logger.i("Content scanned: $qrCodeContent");

        // Aggiunta del controllo
        if ((qrCodeContent.startsWith('http') ||
                qrCodeContent.startsWith('https') ||
                qrCodeContent.startsWith('www.')) ||
            (qrCodeContent.startsWith('https://open.spotify.com/') ||
                qrCodeContent.startsWith('spotify:')) ||
            (qrCodeContent.startsWith('https://wa.me/') ||
                qrCodeContent.startsWith('whatsapp://'))) {
          final code = createCodeSocialTemplate(qrCodeContent);

          await _codesService.addCode(code);
          Get.off(
            () => CodeDetailsScreen(code: code),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          final barcode = Barcode(
            rawValue: qrCodeContent,
            type: barcodeType,
          );

          final scannedCode = CodeModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            barcode: barcode,
            date: DateTime.now(),
            source: CodeSource.scanned,
          );

          await _codesService.addCode(scannedCode);
          Get.to(
            () => CodeDetailsScreen(code: scannedCode),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 500),
          );
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            AppLocalizations.of(context)!
                .code_scanner_screen_scan_qr_empty_toast_error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.code_scanner_screen_scan_qr_read_toast_error} $e',
        );
      }
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }
}

class QRInstructionWidget extends StatelessWidget {
  const QRInstructionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8.r),
          child: Text(
            AppLocalizations.of(context)!.code_scanner_screen_camera_hint,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16.sp,
            ),
          ),
        ),
        Container(
          width: 300.w,
          height: 300.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3.w,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class ZoomSlider extends StatelessWidget {
  final double zoomLevel;
  final ValueChanged<double> onZoomChanged;

  const ZoomSlider({
    super.key,
    required this.zoomLevel,
    required this.onZoomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: zoomLevel,
      onChanged: onZoomChanged,
      activeColor: Theme.of(context).colorScheme.secondary,
      inactiveColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback onToggleFlash;
  final VoidCallback onToggleCamera;
  final VoidCallback onPickImage;

  const ActionButtons({
    super.key,
    required this.onToggleFlash,
    required this.onToggleCamera,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: onToggleFlash,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          heroTag: "btnFlash",
          child: Icon(
            MingCuteIcons.mgc_flashlight_fill,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FloatingActionButton(
          onPressed: onToggleCamera,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          heroTag: "btnCamera",
          child: Icon(
            MingCuteIcons.mgc_camera_rotate_fill,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FloatingActionButton(
          onPressed: onPickImage,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          heroTag: "btnImage",
          child: Icon(
            MingCuteIcons.mgc_pic_fill,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
