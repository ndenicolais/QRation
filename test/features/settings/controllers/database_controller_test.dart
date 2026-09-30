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
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/settings/controllers/database_controller.dart';
import 'package:qration/features/settings/services/backup_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  late MockCodesRepository repository;

  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    repository = MockCodesRepository();
    Get.put<CodesRepository>(repository);
  });

  tearDown(() {
    Get.reset();
  });

  test('loadData populates counters from the repository on success', () async {
    when(() => repository.countAllCodes()).thenAnswer((_) async => 10);
    when(() => repository.countCodesBySource(CodeSource.created))
        .thenAnswer((_) async => 6);
    when(() => repository.countCodesBySource(CodeSource.scanned))
        .thenAnswer((_) async => 4);
    when(() => repository.countCodesByType(CodeSource.created))
        .thenAnswer((_) async => {'text': 6});
    when(() => repository.countSocialCodesByType(CodeSource.created))
        .thenAnswer((_) async => {'instagram': 2});
    when(() => repository.countCodesByType(CodeSource.scanned))
        .thenAnswer((_) async => {'url': 4});
    when(() => repository.countSocialCodesByType(CodeSource.scanned))
        .thenAnswer((_) async => {});

    final controller = DatabaseController();
    await controller.loadData();

    expect(controller.isLoading.value, isFalse);
    expect(controller.hasError.value, isFalse);
    expect(controller.totalCodes.value, 10);
    expect(controller.createdCodesCount.value, 6);
    expect(controller.scannedCodesCount.value, 4);
    expect(controller.standardCodesByCreated.value, {'text': 6});
    expect(controller.socialCodesByCreated.value, {'instagram': 2});
    expect(controller.standardCodesByScanned.value, {'url': 4});
    expect(controller.socialCodesByScanned.value, {});
  });

  test('loadData sets hasError and clears isLoading when the repository throws',
      () async {
    when(() => repository.countAllCodes()).thenThrow(Exception('boom'));

    final controller = DatabaseController();
    await controller.loadData();

    expect(controller.isLoading.value, isFalse);
    expect(controller.hasError.value, isTrue);
  });

  test('loadBackupHistory exposes the stored export and import times',
      () async {
    final exportAt = DateTime(2026, 9, 1, 8, 30);
    await BackupHistory('uid-1').recordExport(exportAt);
    final controller = DatabaseController(userId: 'uid-1');

    await controller.loadBackupHistory();

    expect(controller.lastExportAt.value, exportAt);
    expect(controller.lastImportAt.value, isNull);
  });
}
