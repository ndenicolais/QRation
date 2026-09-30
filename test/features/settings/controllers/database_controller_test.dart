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
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/export/services/csv_service.dart';
import 'package:qration/features/export/services/excel_service.dart';
import 'package:qration/features/export/services/pdf_service.dart';
import 'package:qration/features/settings/controllers/database_controller.dart';
import 'package:qration/features/settings/services/backup_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

class MockPdfService extends Mock implements PdfService {}

class MockExcelService extends Mock implements ExcelService {}

class MockCsvService extends Mock implements CSVService {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  setUpAll(() => registerFallbackValue(FakeBuildContext()));

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

  group('file exports', () {
    late MockPdfService pdf;
    late MockExcelService excel;
    late MockCsvService csv;
    late DatabaseController controller;
    final context = FakeBuildContext();

    setUp(() {
      pdf = MockPdfService();
      excel = MockExcelService();
      csv = MockCsvService();
      controller = DatabaseController();
      controller.attachServices(pdf, excel, csv);
    });

    test('success returns the path and reports progress', () async {
      when(() => pdf.generateCodesPdf(any(), any()))
          .thenAnswer((invocation) async {
        final onProgress =
            invocation.positionalArguments[1] as Function(double);
        onProgress(0.5);
        expect(controller.isFileLoading.value, isTrue);
        expect(controller.downloadProgress.value, 0.5);
        return '/tmp/codes.pdf';
      });

      final path = await controller.generatePdf(context);

      expect(path, '/tmp/codes.pdf');
      expect(controller.isFileLoading.value, isFalse);
    });

    test('failure returns null, keeps the error and stops loading', () async {
      when(() => excel.generateExcel(any(), any()))
          .thenThrow(Exception('disk full'));

      final path = await controller.generateExcel(context);

      expect(path, isNull);
      expect(controller.lastError.toString(), contains('disk full'));
      expect(controller.isFileLoading.value, isFalse);
    });

    test('csv export goes through the csv service', () async {
      when(() => csv.generateCSV(any(), any()))
          .thenAnswer((_) async => '/tmp/codes.csv');

      expect(await controller.generateCSV(context), '/tmp/codes.csv');
      verifyNever(() => pdf.generateCodesPdf(any(), any()));
    });
  });
}
