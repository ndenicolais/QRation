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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/bindings/code_bindings.dart';
import 'package:qration/features/codes/controllers/code_create_social_controller.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/features/home/bindings/home_binding.dart';
import 'package:qration/features/codes/controllers/scanner_controller.dart';
import 'package:qration/features/settings/controllers/settings_controller.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<CodesRepository>(MockCodesRepository());
  });

  tearDown(() {
    Get.routing.args = null;
    Get.reset();
  });

  test('HomeBinding registers the tab controllers lazily', () {
    HomeBinding().dependencies();

    expect(Get.isRegistered<ScannerController>(), isTrue);
    expect(Get.isRegistered<FavoritesController>(), isTrue);
    expect(Get.isRegistered<HistoryController>(), isTrue);
    expect(Get.isRegistered<SettingsController>(), isTrue);
    // Lazy: nothing is instantiated until a screen asks for it.
    expect(Get.isPrepared<HistoryController>(), isTrue);
  });

  group('route argument bindings', () {
    test('standard creation uses the BarcodeType argument', () {
      Get.routing.args = BarcodeType.wifi;
      CodeCreateStandardBinding().dependencies();

      expect(Get.find<CodeCreateStandardController>().type, BarcodeType.wifi);
    });

    test('social creation uses the CodeSocial argument', () {
      final social = CodeSocial(
        name: 'Instagram',
        url: 'https://www.instagram.com/',
        icon: Icons.link,
      );
      Get.routing.args = social;
      CodeCreateSocialBinding().dependencies();

      expect(
        Get.find<CodeCreateSocialController>().socialMedia,
        same(social),
      );
    });

    test('details uses the CodeModel argument', () {
      final code = CodeModel(
        id: '1',
        barcode: const Barcode(rawValue: 'hi', type: BarcodeType.text),
        date: DateTime(2026),
        source: CodeSource.scanned,
      );
      Get.routing.args = code;
      CodeDetailsBinding().dependencies();

      expect(Get.find<CodeDetailsController>().code, same(code));
    });

    test('missing or wrong arguments register nothing', () {
      Get.routing.args = 'not a model';
      CodeCreateStandardBinding().dependencies();
      CodeCreateSocialBinding().dependencies();
      CodeDetailsBinding().dependencies();

      expect(Get.isRegistered<CodeCreateStandardController>(), isFalse);
      expect(Get.isRegistered<CodeCreateSocialController>(), isFalse);
      expect(Get.isRegistered<CodeDetailsController>(), isFalse);
    });
  });
}
