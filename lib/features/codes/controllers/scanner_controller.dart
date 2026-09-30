// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
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
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/utils/code_social_template.dart';
import 'package:qration/core/utils/rescan_guard.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:vibration/vibration.dart';

/// Scan pipeline of the Scanner tab: duplicate filtering, feedback, code
/// creation and persistence. Camera and navigation stay in the screen.
class ScannerController extends GetxController {
  ScannerController({
    RescanGuard? rescanGuard,
    Future<void> Function()? playBeep,
    Future<void> Function()? vibrate,
    this.saveTimeout = const Duration(seconds: 3),
  })  : _rescanGuard = rescanGuard ?? RescanGuard(),
        _playBeep = playBeep,
        _vibrate = vibrate;

  final Duration saveTimeout;
  final RescanGuard _rescanGuard;
  final Future<void> Function()? _playBeep;
  final Future<void> Function()? _vibrate;

  final _logger = Logger();
  final CodesRepository _repository = Get.find<CodesRepository>();
  final ScannerPreferencesController _prefs =
      Get.find<ScannerPreferencesController>();
  AudioPlayer? _audio;

  final isProcessing = false.obs;

  @override
  void onClose() {
    _audio?.dispose();
    super.onClose();
  }

  /// Returns true (and marks processing) if [value] is a new scan to handle.
  bool tryBeginDetection(String value) {
    if (isProcessing.value || !_rescanGuard.accept(value)) return false;
    isProcessing.value = true;
    return true;
  }

  /// Ends processing and restarts the rescan cooldown from now, i.e. from
  /// the return to the scanner rather than from the original detection.
  void endDetection() {
    _rescanGuard.touch();
    isProcessing.value = false;
  }

  /// Beep/vibration according to the current settings. Plugin failures
  /// (e.g. no vibrator or audio output) never block the scan.
  Future<void> playFeedback() async {
    try {
      if (_prefs.beepEnabled) await (_playBeep ?? _defaultBeep)();
    } catch (e) {
      _logger.e('Error playing beep sound: $e');
    }
    try {
      if (_prefs.vibrateEnabled) await (_vibrate ?? _defaultVibrate)();
    } catch (e) {
      _logger.e('Error triggering vibration: $e');
    }
  }

  Future<void> _defaultBeep() async {
    _audio ??= AudioPlayer();
    await _audio!.play(AssetSource('sounds/beep.mp3'));
  }

  Future<void> _defaultVibrate() async {
    if (await Vibration.hasVibrator()) await Vibration.vibrate();
  }

  static bool isSocialUrl(String content) =>
      content.startsWith('http') ||
      content.startsWith('www.') ||
      content.startsWith('spotify:') ||
      content.startsWith('whatsapp://');

  static CodeModel buildCode(String content, BarcodeType type) {
    if (isSocialUrl(content)) return createCodeSocialTemplate(content);
    return CodeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barcode: Barcode(rawValue: content, type: type),
      date: DateTime.now(),
      source: CodeSource.scanned,
    );
  }

  /// Builds and saves the scanned code. A write not acknowledged within
  /// [saveTimeout] is still queued locally by Firestore's offline
  /// persistence, so it doesn't block navigation.
  Future<CodeModel> saveScannedCode(String content, BarcodeType type) async {
    final code = buildCode(content, type);
    try {
      await _repository.addCode(code).timeout(saveTimeout);
    } on TimeoutException {
      // Queued locally, see above.
    }
    return code;
  }
}
