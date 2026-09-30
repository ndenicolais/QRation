// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qration/core/utils/downloads_saver.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/codes/models/code_model.dart';

class CSVService {
  final BuildContext context;
  final CodesRepository codesService;
  final User? currentUser;

  CSVService(this.context, this.codesService, this.currentUser);

  Future<String> generateCSV(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      return await (() async {
        List<CodeModel> codes = await codesService.getCodesStream().first;
        codes.sort((a, b) => b.date.compareTo(a.date));

        List<List<String>> rows = [
          [
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
            '#${code.eyeColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            code.eyeRounded.toString(),
            '#${code.moduleColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            code.moduleRounded.toString(),
            code.isFavorite.toString(),
            code.socialMedia?.name.toString() ?? '-',
          ]);
        }

        final filePath = await _saveCSV(rows);
        onProgress(1.0);
        return filePath;
      })();
    } catch (e) {
      throw Exception('Failed to generate CSV: $e');
    }
  }

  Future<String> _saveCSV(List<List<String>> rows) async {
    String csvData = const ListToCsvConverter().convert(rows);
    final directory = (await getDownloadsDirectory()) ??
        (await getApplicationDocumentsDirectory());
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyyMMdd_HHmmss');
    final formattedDate = dateFormat.format(now);
    final fileName = 'qration_db_$formattedDate.csv';
    final filePath = '${directory.path}/$fileName';
    final bytes = utf8.encode(csvData);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    await saveBytesToPublicDownloads(
      fileName: fileName,
      mimeType: 'text/csv',
      bytes: bytes,
    );
    return filePath;
  }
}
