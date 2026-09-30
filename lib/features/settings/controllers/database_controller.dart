// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/export/services/csv_service.dart';
import 'package:qration/features/export/services/excel_service.dart';
import 'package:qration/features/export/services/pdf_service.dart';

enum ImportResult { success, cancelled, error }

class DatabaseController extends GetxController {
  final CodesRepository _codesService = Get.find<CodesRepository>();

  PdfService? _pdfService;
  ExcelService? _excelService;
  CSVService? _csvService;

  final isLoading = true.obs;
  final hasError = false.obs;
  final isFileLoading = false.obs;
  final isJsonLoading = false.obs;
  final downloadProgress = 0.0.obs;

  final totalCodes = Rxn<int>();
  final createdCodesCount = Rxn<int>();
  final scannedCodesCount = Rxn<int>();
  final standardCodesByCreated = Rxn<Map<String, int>>();
  final socialCodesByCreated = Rxn<Map<String, int>>();
  final standardCodesByScanned = Rxn<Map<String, int>>();
  final socialCodesByScanned = Rxn<Map<String, int>>();

  Object? lastError;

  void attachServices(
    PdfService pdfService,
    ExcelService excelService,
    CSVService csvService,
  ) {
    _pdfService = pdfService;
    _excelService = excelService;
    _csvService = csvService;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      totalCodes.value = await _codesService.countAllCodes();
      createdCodesCount.value =
          await _codesService.countCodesBySource(CodeSource.created);
      scannedCodesCount.value =
          await _codesService.countCodesBySource(CodeSource.scanned);
      standardCodesByCreated.value =
          await _codesService.countCodesByType(CodeSource.created);
      socialCodesByCreated.value =
          await _codesService.countSocialCodesByType(CodeSource.created);
      standardCodesByScanned.value =
          await _codesService.countCodesByType(CodeSource.scanned);
      socialCodesByScanned.value =
          await _codesService.countSocialCodesByType(CodeSource.scanned);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
    }
  }

  Future<String?> _runExport(
    BuildContext context,
    Future<String> Function(
            BuildContext context, void Function(double) onProgress)
        generate,
  ) async {
    isFileLoading.value = true;
    downloadProgress.value = 0.0;
    try {
      final filePath = await generate(
        context,
        (progress) => downloadProgress.value = progress,
      );
      return filePath;
    } catch (e) {
      lastError = e;
      return null;
    } finally {
      isFileLoading.value = false;
    }
  }

  Future<String?> generatePdf(BuildContext context) => _runExport(
        context,
        (ctx, onProgress) => _pdfService!.generateCodesPdf(ctx, onProgress),
      );

  Future<String?> generateExcel(BuildContext context) => _runExport(
        context,
        (ctx, onProgress) => _excelService!.generateExcel(ctx, onProgress),
      );

  Future<String?> generateCSV(BuildContext context) => _runExport(
        context,
        (ctx, onProgress) => _csvService!.generateCSV(ctx, onProgress),
      );

  Future<bool> exportCodes() async {
    isJsonLoading.value = true;
    try {
      final jsonCodes = await _codesService.exportCodesToJson();
      final directory = (await getDownloadsDirectory()) ??
          (await getApplicationDocumentsDirectory());
      final formattedDate =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/qration_db_$formattedDate.json';
      final file = File(filePath);
      await file.writeAsString(jsonCodes);
      return true;
    } catch (e) {
      lastError = e;
      return false;
    } finally {
      isJsonLoading.value = false;
    }
  }

  Future<ImportResult> importCodes() async {
    isJsonLoading.value = true;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        return ImportResult.cancelled;
      }

      File file = File(result.files.single.path!);
      String jsonCodes = await file.readAsString();
      await _codesService.importCodesFromJson(jsonCodes);
      return ImportResult.success;
    } catch (e) {
      lastError = e;
      return ImportResult.error;
    } finally {
      isJsonLoading.value = false;
    }
  }
}
