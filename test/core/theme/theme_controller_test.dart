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
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  Future<ThemeController> createController() async {
    final controller = Get.put(ThemeController());
    await pumpEventQueue();
    return controller;
  }

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
    binding.platformDispatcher.clearPlatformBrightnessTestValue();
  });

  test('defaults to system mode when nothing is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = await createController();

    expect(controller.themeMode, ThemeMode.system);
  });

  test('migrates the legacy dark bool and removes the old key', () async {
    SharedPreferences.setMockInitialValues(
        {ThemeController.legacyThemeKey: true});
    final controller = await createController();
    final prefs = await SharedPreferences.getInstance();

    expect(controller.themeMode, ThemeMode.dark);
    expect(prefs.getString(ThemeController.themeModeKey), 'dark');
    expect(prefs.containsKey(ThemeController.legacyThemeKey), isFalse);
  });

  test('migrates the legacy light bool', () async {
    SharedPreferences.setMockInitialValues(
        {ThemeController.legacyThemeKey: false});
    final controller = await createController();

    expect(controller.themeMode, ThemeMode.light);
  });

  test('stored three-state value takes precedence over the legacy key',
      () async {
    SharedPreferences.setMockInitialValues({
      ThemeController.themeModeKey: 'system',
      ThemeController.legacyThemeKey: true,
    });
    final controller = await createController();

    expect(controller.themeMode, ThemeMode.system);
  });

  test('setThemeMode updates state and persists the mode name', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = await createController();

    await controller.setThemeMode(ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();

    expect(controller.themeMode, ThemeMode.dark);
    expect(prefs.getString(ThemeController.themeModeKey), 'dark');
  });

  test('isDark follows platform brightness in system mode', () async {
    SharedPreferences.setMockInitialValues(
        {ThemeController.themeModeKey: 'system'});
    final controller = await createController();

    binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    expect(controller.isDark, isTrue);

    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    expect(controller.isDark, isFalse);
  });
}
