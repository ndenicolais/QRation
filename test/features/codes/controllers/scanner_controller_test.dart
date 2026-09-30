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

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/utils/rescan_guard.dart';
import 'package:qration/features/codes/controllers/scanner_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

class FakeCodeModel extends Fake implements CodeModel {}

void main() {
  late MockCodesRepository repository;
  late ScannerPreferencesController prefs;
  late int beeps;
  late int vibrations;
  late DateTime now;

  setUpAll(() => registerFallbackValue(FakeCodeModel()));

  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    repository = MockCodesRepository();
    Get.put<CodesRepository>(repository);
    prefs = Get.put(ScannerPreferencesController());
    await pumpEventQueue();
    beeps = 0;
    vibrations = 0;
    now = DateTime(2026, 1, 1, 12);
  });

  tearDown(Get.reset);

  ScannerController create({Duration? saveTimeout}) => Get.put(
        ScannerController(
          rescanGuard: RescanGuard(clock: () => now),
          playBeep: () async => beeps++,
          vibrate: () async => vibrations++,
          saveTimeout: saveTimeout ?? const Duration(seconds: 3),
        ),
      );

  group('detection', () {
    test('accepts a new code and blocks others while processing', () {
      final controller = create();

      expect(controller.tryBeginDetection('A'), isTrue);
      expect(controller.isProcessing.value, isTrue);
      expect(controller.tryBeginDetection('B'), isFalse);
    });

    test('same code is ignored right after returning from details', () {
      final controller = create();
      controller.tryBeginDetection('A');
      now = now.add(const Duration(seconds: 10));
      controller.endDetection();

      expect(controller.isProcessing.value, isFalse);
      expect(controller.tryBeginDetection('A'), isFalse);

      now = now.add(const Duration(seconds: 3));
      expect(controller.tryBeginDetection('A'), isTrue);
    });
  });

  group('feedback', () {
    test('follows the current preferences', () async {
      final controller = create();

      await controller.playFeedback();
      expect((beeps, vibrations), (0, 0));

      await prefs.setBeep(true);
      await prefs.setVibrate(true);
      await controller.playFeedback();
      expect((beeps, vibrations), (1, 1));
    });

    test('a failing beep does not prevent vibration', () async {
      await prefs.setBeep(true);
      await prefs.setVibrate(true);
      final controller = Get.put(ScannerController(
        playBeep: () async => throw Exception('no audio'),
        vibrate: () async => vibrations++,
      ));

      await controller.playFeedback();

      expect(vibrations, 1);
    });
  });

  group('codes', () {
    test('isSocialUrl recognizes web and app links', () {
      expect(ScannerController.isSocialUrl('https://x.com/me'), isTrue);
      expect(ScannerController.isSocialUrl('www.example.com'), isTrue);
      expect(ScannerController.isSocialUrl('spotify:search:a;b'), isTrue);
      expect(ScannerController.isSocialUrl('whatsapp://send'), isTrue);
      expect(ScannerController.isSocialUrl('WIFI:T:WPA;S:x;;'), isFalse);
    });

    test('buildCode keeps plain content as a scanned code', () {
      final code = ScannerController.buildCode('hello', BarcodeType.text);

      expect(code.barcode.rawValue, 'hello');
      expect(code.barcode.type, BarcodeType.text);
      expect(code.source, CodeSource.scanned);
      expect(code.socialMedia, isNull);
    });

    test('saveScannedCode persists the code', () async {
      when(() => repository.addCode(any())).thenAnswer((_) async {});
      final controller = create();

      final code = await controller.saveScannedCode('hello', BarcodeType.text);

      verify(() => repository.addCode(code)).called(1);
    });

    test('saveScannedCode does not wait past the timeout', () async {
      final pending = Completer<void>();
      when(() => repository.addCode(any())).thenAnswer((_) => pending.future);
      final controller = create(saveTimeout: const Duration(milliseconds: 10));

      final code = await controller.saveScannedCode('hello', BarcodeType.text);

      expect(code.barcode.rawValue, 'hello');
    });

    test('saveScannedCode propagates real errors', () async {
      when(() => repository.addCode(any())).thenThrow(Exception('denied'));
      final controller = create();

      expect(
        controller.saveScannedCode('hello', BarcodeType.text),
        throwsException,
      );
    });
  });
}
