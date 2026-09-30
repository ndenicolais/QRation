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

class ThemeController extends GetxController with WidgetsBindingObserver {
  static const String themeModeKey = 'theme_mode';
  static const String legacyThemeKey = 'theme_preference';
  static const String accentKey = 'accent_preset_index';

  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  /// Effective brightness, resolving [ThemeMode.system] against the platform.
  bool get isDark => switch (_themeMode.value) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark,
      };

  final _accentIndex = 0.obs;
  int get accentIndex => _accentIndex.value;
  AccentPreset get currentAccent => AccentPresets.all[_accentIndex.value];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode.value == ThemeMode.system) _applySystemChrome();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode.value = await _readThemeMode(prefs);
    final storedAccent = prefs.getInt(accentKey) ?? 0;
    _accentIndex.value =
        storedAccent >= 0 && storedAccent < AccentPresets.all.length
            ? storedAccent
            : 0;
    _applySystemChrome();
  }

  /// Reads the three-state preference, migrating the legacy light/dark bool.
  Future<ThemeMode> _readThemeMode(SharedPreferences prefs) async {
    final stored = prefs.getString(themeModeKey);
    if (stored != null) {
      return ThemeMode.values.firstWhere(
        (mode) => mode.name == stored,
        orElse: () => ThemeMode.system,
      );
    }
    final legacy = prefs.getBool(legacyThemeKey);
    if (legacy == null) return ThemeMode.system;
    final migrated = legacy ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(themeModeKey, migrated.name);
    await prefs.remove(legacyThemeKey);
    return migrated;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    _applySystemChrome();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeModeKey, mode.name);
  }

  Future<void> setAccent(int index) async {
    if (index < 0 || index >= AccentPresets.all.length) return;
    _accentIndex.value = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(accentKey, index);
  }

  void _applySystemChrome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dark = isDark;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            dark ? AppColors.surfaceDark : AppColors.surfaceLight,
        systemNavigationBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
      ));
    });
  }
}
