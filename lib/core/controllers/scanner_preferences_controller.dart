// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Scan feedback preferences shared between Settings and the scanner, so a
/// change in Settings applies immediately without restarting the app.
class ScannerPreferencesController extends GetxController {
  static const String beepKey = 'beepEnabled';
  static const String vibrateKey = 'vibrateEnabled';

  final _beepEnabled = false.obs;
  final _vibrateEnabled = false.obs;

  bool get beepEnabled => _beepEnabled.value;
  bool get vibrateEnabled => _vibrateEnabled.value;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _beepEnabled.value = prefs.getBool(beepKey) ?? false;
    _vibrateEnabled.value = prefs.getBool(vibrateKey) ?? false;
  }

  Future<void> setBeep(bool value) async {
    _beepEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(beepKey, value);
  }

  Future<void> setVibrate(bool value) async {
    _vibrateEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(vibrateKey, value);
  }
}
