// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/accent_presets.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_preference';
  static const String _accentKey = 'accent_preset_index';

  final _isDark = false.obs;
  bool get isDark => _isDark.value;

  final _accentIndex = 0.obs;
  int get accentIndex => _accentIndex.value;
  AccentPreset get currentAccent => AccentPresets.all[_accentIndex.value];

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark.value = prefs.getBool(_themeKey) ?? false;
    final storedAccent = prefs.getInt(_accentKey) ?? 0;
    _accentIndex.value =
        storedAccent >= 0 && storedAccent < AccentPresets.all.length
            ? storedAccent
            : 0;
    _applySystemChrome(_isDark.value);
  }

  Future<void> toggleTheme() async {
    _isDark.value = !_isDark.value;
    _applySystemChrome(_isDark.value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark.value);
  }

  Future<void> setDark() async {
    _isDark.value = true;
    _applySystemChrome(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, true);
  }

  Future<void> setLight() async {
    _isDark.value = false;
    _applySystemChrome(false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, false);
  }

  Future<void> setAccent(int index) async {
    if (index < 0 || index >= AccentPresets.all.length) return;
    _accentIndex.value = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentKey, index);
  }

  void _applySystemChrome(bool isDark) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ));
    });
  }
}
