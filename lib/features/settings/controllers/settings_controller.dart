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
import 'package:qration/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final _isDark = false.obs;
  final _beepEnabled = false.obs;
  final _vibrateEnabled = false.obs;
  final _accentIndex = 0.obs;

  bool get isDark => _isDark.value;
  bool get beepEnabled => _beepEnabled.value;
  bool get vibrateEnabled => _vibrateEnabled.value;
  int get accentIndex => _accentIndex.value;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark.value = prefs.getBool('theme_preference') ?? false;
    _beepEnabled.value = prefs.getBool('beepEnabled') ?? false;
    _vibrateEnabled.value = prefs.getBool('vibrateEnabled') ?? false;
    _accentIndex.value = Get.find<ThemeController>().accentIndex;
  }

  Future<void> toggleTheme(bool value) async {
    _isDark.value = value;
    final themeController = Get.find<ThemeController>();
    if (value) {
      themeController.setDark();
    } else {
      themeController.setLight();
    }
  }

  Future<void> setAccent(int index) async {
    _accentIndex.value = index;
    await Get.find<ThemeController>().setAccent(index);
  }

  Future<void> toggleBeep(bool value) async {
    _beepEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('beepEnabled', value);
  }

  Future<void> toggleVibrate(bool value) async {
    _vibrateEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrateEnabled', value);
  }
}
