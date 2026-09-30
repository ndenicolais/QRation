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
import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/core/utils/code_type_text.dart';
import 'package:qration/core/utils/downloads_saver.dart';

class ExcelService {
  final BuildContext context;
  final CodesRepository codesService;
  final User? currentUser;

  ExcelService(this.context, this.codesService, this.currentUser);

  Future<String> generateExcel(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      return await (() async {
        List<CodeModel> codes = await codesService.getCodesStream().first;
        codes.sort((a, b) => b.date.compareTo(a.date));

        final Excel excel = Excel.createExcel();
        final String sheetName = 'QRationData';
        excel.rename(excel.getDefaultSheet()!, sheetName);
        final Sheet sheet = excel[sheetName];

        CellStyle titleStyle = CellStyle(
          fontFamily: 'Montserrat',
          fontSize: 24,
          bold: true,
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = TextCellValue('QRation');
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .cellStyle = titleStyle;
        sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
            CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));

        CellStyle headerStyle = CellStyle(
          fontFamily: 'Montserrat',
          bold: true,
        );

        CellStyle rowStyle = CellStyle(
          fontFamily: 'Montserrat',
          textWrapping: TextWrapping.WrapText,
        );

        final headers = [
          l10n.database_service_codes_field_id,
          l10n.database_service_codes_field_date,
          l10n.database_service_codes_field_source,
          l10n.database_service_codes_field_type,
          l10n.database_service_codes_field_content,
          l10n.database_service_codes_field_eye_color,
          l10n.database_service_codes_field_eye_rounded,
          l10n.database_service_codes_field_module_color,
          l10n.database_service_codes_field_module_rounded,
          l10n.database_service_codes_field_favorite,
          l10n.database_service_codes_field_social,
        ];

        for (int col = 0; col < headers.length; col++) {
          var cell = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
          cell.value = TextCellValue(headers[col]);
          cell.cellStyle = headerStyle;
        }

        final int totalCodes = codes.length;
        for (int i = 0; i < totalCodes; i++) {
          CodeModel code = codes[i];
          String formattedDate = DateFormat('yyyy-MM-dd').format(code.date);
          var readableType = CodeTypeText.fromBarcodeType(
            fromStringToBarcodeType(
                code.barcode.type.toString().split('.').last),
            code.barcode.type.toString().split('.').last,
            l10n,
          ).type;
          final row = [
            TextCellValue(code.id),
            TextCellValue(formattedDate),
            TextCellValue(code.source.toString().split('.').last),
            TextCellValue(readableType),
            TextCellValue(code.barcode.rawValue ?? ''),
            TextCellValue(
                '#${code.eyeColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'),
            TextCellValue(code.eyeRounded.toString()),
            TextCellValue(
                '#${code.moduleColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'),
            TextCellValue(code.moduleRounded.toString()),
            TextCellValue(code.isFavorite.toString()),
            TextCellValue(code.socialMedia?.name.toString() ?? '-'),
          ];

          for (int col = 0; col < row.length; col++) {
            var cell = sheet.cell(CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: codes.indexOf(code) + 2));
            cell.value = row[col];
            cell.cellStyle = rowStyle;
          }
          double progress = ((i + 1) / totalCodes) * 0.8;
          onProgress(progress);
        }

        for (int col = 0; col < headers.length; col++) {
          double maxLength = headers[col].length.toDouble();

          for (int row = 1; row <= codes.length; row++) {
            String? cellValue = sheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: col, rowIndex: row + 1))
                .value
                .toString();
            maxLength = max(maxLength, cellValue.length.toDouble());
          }

          double pixelWidth = maxLength * 10.0;
          sheet.setColumnWidth(col, pixelWidth / 7.0);
        }

        final filePath = await _saveExcel(excel);
        onProgress(1.0);
        return filePath;
      })();
    } catch (e) {
      throw Exception('Failed to generate Excel: $e');
    }
  }
}

Future<String> _saveExcel(Excel excel) async {
  final fileBytes = excel.save()!;
  final directory = (await getDownloadsDirectory()) ??
      (await getApplicationDocumentsDirectory());
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyyMMdd_HHmmss');
  final formattedDate = dateFormat.format(now);
  final fileName = 'qration_db_$formattedDate.xlsx';
  final filePath = '${directory.path}/$fileName';
  final bytes = Uint8List.fromList(fileBytes);
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  await saveBytesToPublicDownloads(
    fileName: fileName,
    mimeType:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    bytes: bytes,
  );
  return filePath;
}
