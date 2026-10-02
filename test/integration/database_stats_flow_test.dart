// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais
//
// Multi-layer test: wires a real `DatabaseController` to a mocked
// `CodesRepository` and pumps the real `StatisticsSection`/`ExportImportSection`
// widgets on top of it, verifying controller state flows through to what
// is actually rendered on screen — closer to an end-to-end flow than a
// single-widget/single-unit test, without requiring a device or emulator.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/settings/controllers/database_controller.dart';
import 'package:qration/features/settings/widgets/export_import_section.dart';
import 'package:qration/features/settings/widgets/statistics_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/widget_test_helpers.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  late MockCodesRepository repository;
  late DatabaseController controller;

  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    repository = MockCodesRepository();
    Get.put<CodesRepository>(repository);

    when(() => repository.countAllCodes()).thenAnswer((_) async => 7);
    when(() => repository.countCodesBySource(CodeSource.created))
        .thenAnswer((_) async => 5);
    when(() => repository.countCodesBySource(CodeSource.scanned))
        .thenAnswer((_) async => 2);
    when(() => repository.countCodesByType(CodeSource.created))
        .thenAnswer((_) async => {'text': 5});
    when(() => repository.countSocialCodesByType(CodeSource.created))
        .thenAnswer((_) async => {});
    when(() => repository.countCodesByType(CodeSource.scanned))
        .thenAnswer((_) async => {'url': 2});
    when(() => repository.countSocialCodesByType(CodeSource.scanned))
        .thenAnswer((_) async => {});

    controller = Get.put(DatabaseController());
    await controller.loadData();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'loaded controller counts are reflected in the statistics widgets',
    (tester) async {
      await pumpLocalizedWidget(
        tester,
        Obx(
          () => StatisticsSection(
            totalCodes: controller.totalCodes.value,
            createdCodesCount: controller.createdCodesCount.value,
            scannedCodesCount: controller.scannedCodesCount.value,
            standardCodesByCreated: controller.standardCodesByCreated.value,
            socialCodesByCreated: controller.socialCodesByCreated.value,
            standardCodesByScanned: controller.standardCodesByScanned.value,
            socialCodesByScanned: controller.socialCodesByScanned.value,
          ),
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets(
    'export section renders alongside the loaded statistics without error',
    (tester) async {
      await pumpLocalizedWidget(
        tester,
        Column(
          children: [
            Obx(
              () => StatisticsSection(
                totalCodes: controller.totalCodes.value,
                createdCodesCount: controller.createdCodesCount.value,
                scannedCodesCount: controller.scannedCodesCount.value,
                standardCodesByCreated: controller.standardCodesByCreated.value,
                socialCodesByCreated: controller.socialCodesByCreated.value,
                standardCodesByScanned: controller.standardCodesByScanned.value,
                socialCodesByScanned: controller.socialCodesByScanned.value,
              ),
            ),
            ExportImportSection(
              onPdf: () {},
              onExcel: () {},
              onCsv: () {},
              onBackup: () {},
              onRestore: () {},
              lastBackupAt: null,
              lastRestoreAt: null,
            ),
          ],
        ),
      );

      expect(find.byType(StatisticsSection), findsOneWidget);
      expect(find.byType(ExportImportSection), findsOneWidget);
    },
  );
}
