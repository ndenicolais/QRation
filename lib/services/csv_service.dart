import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/utils/permission_helper.dart';
import 'package:qration/models/code_model.dart';

class CSVService {
  final BuildContext context;
  final CodesService codesService;
  final User? currentUser;

  CSVService(this.context, this.codesService, this.currentUser);

  Future<String> generateCSV(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      return await requestStoragePermission(context, () async {
        List<CodeModel> codes = await codesService.getCodesStream().first;
        codes.sort((a, b) => b.date.compareTo(a.date));

        List<List<String>> rows = [
          [
            AppLocalizations.of(context)!.database_service_codes_field_id,
            AppLocalizations.of(context)!.database_service_codes_field_date,
            AppLocalizations.of(context)!.database_service_codes_field_source,
            AppLocalizations.of(context)!.database_service_codes_field_type,
            AppLocalizations.of(context)!.database_service_codes_field_content,
            AppLocalizations.of(context)!
                .database_service_codes_field_eye_color,
            AppLocalizations.of(context)!
                .database_service_codes_field_eye_rounded,
            AppLocalizations.of(context)!
                .database_service_codes_field_module_color,
            AppLocalizations.of(context)!
                .database_service_codes_field_module_rounded,
            AppLocalizations.of(context)!.database_service_codes_field_favorite,
            AppLocalizations.of(context)!.database_service_codes_field_social,
          ],
        ];

        // Aggiunta dei dati al CSV
        for (var code in codes) {
          rows.add([
            code.id,
            code.date.toIso8601String(),
            code.source.toString().split('.').last,
            code.barcode.type.toString().split('.').last,
            (code.barcode.rawValue ?? ''),
            '#${code.eyeColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            code.eyeRounded.toString(),
            '#${code.moduleColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            code.moduleRounded.toString(),
            code.isFavorite.toString(),
            code.socialMedia?.name.toString() ?? '-',
          ]);
        }

        final filePath = await _saveCSV(rows);
        onProgress(1.0);
        return filePath;
      });
    } catch (e) {
      throw Exception('Failed to generate CSV: $e');
    }
  }

  Future<String> _saveCSV(List<List<String>> rows) async {
    String csvData = const ListToCsvConverter().convert(rows);
    final directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()) {
      throw Exception('Directory does not exist');
    }
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyyMMdd_HHmmss');
    final formattedDate = dateFormat.format(now);
    final filePath = '${directory.path}/qration_db_$formattedDate.csv';
    final file = File(filePath);
    await file.writeAsString(csvData);
    return filePath;
  }
}
