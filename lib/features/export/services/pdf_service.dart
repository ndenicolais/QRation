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
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/core/utils/code_type_text.dart';
import 'package:qration/core/utils/downloads_saver.dart';
import 'package:qration/features/export/services/pdf_report.dart';

/// Collects the codes and account details, renders each QR and saves the
/// report laid out by [buildPdfReport].
class PdfService {
  final BuildContext context;
  final CodesRepository codesService;
  final User? currentUser;

  PdfService(this.context, this.codesService, this.currentUser);

  Future<String> generateCodesPdf(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final codes = await codesService.getCodesStream().first;
      codes.sort((a, b) => b.date.compareTo(a.date));
      onProgress(0.05);

      final items = <PdfReportCode>[];
      for (var i = 0; i < codes.length; i++) {
        items.add(PdfReportCode(
          code: codes[i],
          readableType: readableCodeType(codes[i], l10n),
          qrPng: await _renderQr(codes[i]),
        ));
        // QR rendering is the slow part: it drives most of the progress.
        onProgress(0.05 + (i + 1) / codes.length * 0.85);
      }

      final user = currentUser;
      final data = PdfReportData(
        exportedAt: DateTime.now(),
        userId: user?.uid ?? '-',
        userName: user?.displayName ?? '-',
        userEmail: user?.email ?? '-',
        accountCreatedAt: user?.metadata.creationTime,
        createdByType: countByType(items.where((c) => c.isCreated)),
        scannedByType: countByType(items.where((c) => !c.isCreated)),
        codes: items,
      );
      final doc = buildPdfReport(
        data: data,
        assets: await loadPdfReportAssets(),
        l10n: l10n,
      );

      final filePath = await _savePdf(doc);
      onProgress(1.0);
      return filePath;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

/// "URL", "Wi-Fi"… in the current language.
String readableCodeType(CodeModel code, AppLocalizations l10n) {
  final typeName = code.barcode.type.toString().split('.').last;
  return CodeTypeText.fromBarcodeType(
    fromStringToBarcodeType(typeName),
    typeName,
    l10n,
  ).type;
}

/// Social codes are counted by network, the others by type, so a social
/// code (a URL underneath) is not counted twice.
PdfTypeCounts countByType(Iterable<PdfReportCode> codes) {
  final standard = <String, int>{};
  final social = <String, int>{};
  for (final item in codes) {
    final network = item.socialName;
    if (network != null) {
      social[network] = (social[network] ?? 0) + 1;
    } else {
      standard[item.readableType] = (standard[item.readableType] ?? 0) + 1;
    }
  }
  return PdfTypeCounts(standard: standard, social: social);
}

Future<PdfReportAssets> loadPdfReportAssets() async {
  final regular = await rootBundle.load('assets/fonts/Montserrat.ttf');
  final bold = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');
  final logo = await rootBundle.load('assets/images/app_logo.png');
  return PdfReportAssets(
    regular: pw.Font.ttf(regular),
    bold: pw.Font.ttf(bold),
    logo: pw.MemoryImage(logo.buffer.asUint8List()),
  );
}

/// The code with its own colors, shapes and logo, as in the app.
Future<Uint8List> _renderQr(CodeModel code) async {
  final qrCode = QrCode.fromData(
    data: code.barcode.rawValue ?? '',
    errorCorrectLevel:
        code.logoPath != null ? QrErrorCorrectLevel.H : QrErrorCorrectLevel.M,
  );
  final logoExists = code.logoPath != null && File(code.logoPath!).existsSync();
  final image = await QrImage(qrCode).toImageAsBytes(
    size: 300,
    format: ui.ImageByteFormat.png,
    decoration: buildQrDecoration(
      eyeColor: code.eyeColor,
      eyeRounded: code.eyeRounded,
      moduleColor: code.moduleColor,
      moduleRounded: code.moduleRounded,
      logoImage: logoExists ? FileImage(File(code.logoPath!)) : null,
    ),
  );
  return image!.buffer.asUint8List();
}

Future<String> _savePdf(pw.Document pdf) async {
  final directory = (await getDownloadsDirectory()) ??
      (await getApplicationDocumentsDirectory());
  final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  final fileName = 'qration_db_$formattedDate.pdf';
  final filePath = '${directory.path}/$fileName';
  final bytes = await pdf.save();
  await File(filePath).writeAsBytes(bytes);
  await saveBytesToPublicDownloads(
    fileName: fileName,
    mimeType: 'application/pdf',
    bytes: bytes,
  );
  return filePath;
}
