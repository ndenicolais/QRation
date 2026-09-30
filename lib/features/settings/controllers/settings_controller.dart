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
import 'package:get/get.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/theme/theme_controller.dart';

/// Facade over the app-wide preference controllers: state lives in
/// [ThemeController] and [ScannerPreferencesController], so every screen
/// observing them reacts to changes made here.
class SettingsController extends GetxController {
  final _theme = Get.find<ThemeController>();
  final _scanner = Get.find<ScannerPreferencesController>();

  ThemeMode get themeMode => _theme.themeMode;
  int get accentIndex => _theme.accentIndex;
  bool get beepEnabled => _scanner.beepEnabled;
  bool get vibrateEnabled => _scanner.vibrateEnabled;

  Future<void> setThemeMode(ThemeMode mode) => _theme.setThemeMode(mode);

  Future<void> setAccent(int index) => _theme.setAccent(index);

  Future<void> toggleBeep(bool value) => _scanner.setBeep(value);

  Future<void> toggleVibrate(bool value) => _scanner.setVibrate(value);
}
