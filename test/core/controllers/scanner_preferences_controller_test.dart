// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ScannerPreferencesController> createController() async {
    final controller = Get.put(ScannerPreferencesController());
    await pumpEventQueue();
    return controller;
  }

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  test('defaults to beep and vibration disabled', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = await createController();

    expect(controller.beepEnabled, isFalse);
    expect(controller.vibrateEnabled, isFalse);
  });

  test('loads stored preferences', () async {
    SharedPreferences.setMockInitialValues({
      ScannerPreferencesController.beepKey: true,
      ScannerPreferencesController.vibrateKey: true,
    });
    final controller = await createController();

    expect(controller.beepEnabled, isTrue);
    expect(controller.vibrateEnabled, isTrue);
  });

  test('setters update state immediately and persist', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = await createController();

    await controller.setBeep(true);
    await controller.setVibrate(true);
    final prefs = await SharedPreferences.getInstance();

    expect(controller.beepEnabled, isTrue);
    expect(controller.vibrateEnabled, isTrue);
    expect(prefs.getBool(ScannerPreferencesController.beepKey), isTrue);
    expect(prefs.getBool(ScannerPreferencesController.vibrateKey), isTrue);
  });
}
