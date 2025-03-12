import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/utils/code_type_text.dart';
import 'package:qration/utils/permission_helper.dart';

class ExcelService {
  final BuildContext context;
  final CodesService codesService;
  final User? currentUser;

  ExcelService(this.context, this.codesService, this.currentUser);

  Future<String> generateExcel(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      return await requestStoragePermission(context, () async {
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
          AppLocalizations.of(context)!.database_service_codes_field_id,
          AppLocalizations.of(context)!.database_service_codes_field_date,
          AppLocalizations.of(context)!.database_service_codes_field_source,
          AppLocalizations.of(context)!.database_service_codes_field_type,
          AppLocalizations.of(context)!.database_service_codes_field_content,
          AppLocalizations.of(context)!.database_service_codes_field_eye_color,
          AppLocalizations.of(context)!
              .database_service_codes_field_eye_rounded,
          AppLocalizations.of(context)!
              .database_service_codes_field_module_color,
          AppLocalizations.of(context)!
              .database_service_codes_field_module_rounded,
          AppLocalizations.of(context)!.database_service_codes_field_favorite,
          AppLocalizations.of(context)!.database_service_codes_field_social,
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
          ).type;
          final row = [
            TextCellValue(code.id),
            TextCellValue(formattedDate),
            TextCellValue(code.source.toString().split('.').last),
            TextCellValue(readableType),
            TextCellValue(code.barcode.rawValue ?? ''),
            TextCellValue(
                '#${code.eyeColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'),
            TextCellValue(code.eyeRounded.toString()),
            TextCellValue(
                '#${code.moduleColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'),
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
      });
    } catch (e) {
      throw Exception('Failed to generate Excel: $e');
    }
  }
}

Future<String> _saveExcel(Excel excel) async {
  final fileBytes = excel.save()!;
  final directory = Directory('/storage/emulated/0/Download');
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyyMMdd_HHmmss');
  final formattedDate = dateFormat.format(now);
  final filePath = '${directory.path}/qration_db_$formattedDate.xlsx';
  final file = File(filePath);
  await file.writeAsBytes(fileBytes);
  return filePath;
}
