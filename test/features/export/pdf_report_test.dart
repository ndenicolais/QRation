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
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/export/services/pdf_report.dart';
import 'package:qration/features/export/services/pdf_service.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Set QRATION_PDF_PREVIEW to a file path to also write the sample report,
/// e.g. to look at the layout without exporting from a device.
final _previewPath = Platform.environment['QRATION_PDF_PREVIEW'];

PdfReportAssets _assets() {
  pw.Font font(String path) =>
      pw.Font.ttf(ByteData.sublistView(File(path).readAsBytesSync()));
  return PdfReportAssets(
    regular: font('assets/fonts/Montserrat.ttf'),
    bold: font('assets/fonts/Montserrat-Bold.ttf'),
    logo: pw.MemoryImage(
      File('assets/images/app_logo.png').readAsBytesSync(),
    ),
  );
}

List<CodeModel> _sampleCodes() {
  final urls = [
    'https://app.wizconnected.com',
    'https://self2.pinapp.pro/?qrcode=47c427d5d0b4a889050f2f1dd6fe321a46c32987d4f673a277ef9f3cfb74cf5a',
    'https://www.osteriadeiregubbio.com/menu/',
    'https://alexa.amazon.it/settings/account/voice-purchasing?ref_=pe_1725760_66985271',
  ];
  final codes = <CodeModel>[
    CodeModel(
      id: 'wifi',
      barcode: Barcode(
        rawValue: 'WIFI:S:Casa;T:WPA;P:password-di-esempio;;',
        type: BarcodeType.wifi,
      ),
      date: DateTime(2026, 9, 30, 21, 15),
      source: CodeSource.created,
      isFavorite: true,
      eyeColor: const Color(0xFF274060),
      eyeRounded: 1,
      moduleColor: const Color(0xFFCCA775),
      moduleRounded: 1,
      notes: 'Rete di casa, da dare agli ospiti.',
    ),
    CodeModel(
      id: 'instagram',
      barcode: Barcode(
        rawValue: 'https://www.instagram.com/qration',
        type: BarcodeType.url,
      ),
      date: DateTime(2026, 9, 29, 10, 30),
      source: CodeSource.created,
      eyeColor: const Color(0xFFCB1F24),
      moduleColor: const Color(0xFFCB1F24),
      socialMedia: _social('Instagram'),
    ),
  ];
  for (var i = 0; i < 32; i++) {
    final url = urls[i % urls.length];
    codes.add(CodeModel(
      id: 'code-$i',
      barcode: Barcode(rawValue: url, type: BarcodeType.url),
      date: DateTime(2026, 9, 28).subtract(Duration(days: i * 9)),
      source: CodeSource.scanned,
      isFavorite: i % 7 == 0,
      socialMedia: _social('Link'),
    ));
  }
  return codes;
}

CodeSocial _social(String name) =>
    CodeSocial(name: name, url: '', icon: Icons.link);

Future<Uint8List> _qr(CodeModel code) async {
  final image = await QrImage(QrCode.fromData(
    data: code.barcode.rawValue ?? '',
    errorCorrectLevel: QrErrorCorrectLevel.M,
  )).toImageAsBytes(size: 300, format: ui.ImageByteFormat.png);
  return image!.buffer.asUint8List();
}

void main() {
  testWidgets('lays out the sample export on a few pages', (tester) async {
    await initializeDateFormatting('it');
    final l10n = await AppLocalizations.delegate.load(const Locale('it'));
    final bytes = await tester.runAsync(() async {
      final items = <PdfReportCode>[
        for (final code in _sampleCodes())
          PdfReportCode(
            code: code,
            readableType: readableCodeType(code, l10n),
            qrPng: await _qr(code),
          ),
      ];
      final data = PdfReportData(
        exportedAt: DateTime(2026, 10, 2, 15, 0),
        userId: 'TeWhiEpVwXOBlimoFiVy9tnBpyn1',
        userName: 'Nicola De Nicolais',
        userEmail: 'utente@example.com',
        accountCreatedAt: DateTime(2025, 3, 12),
        createdByType: countByType(items.where((c) => c.isCreated)),
        scannedByType: countByType(items.where((c) => !c.isCreated)),
        codes: items,
      );
      final doc = buildPdfReport(data: data, assets: _assets(), l10n: l10n);
      return doc.save();
    });

    expect(bytes, isNotNull);
    // One page per code before the redesign (36 for this sample).
    final pages = RegExp(r'/Type\s*/Page\b').allMatches(
      String.fromCharCodes(bytes!),
    );
    expect(pages.length, lessThan(15));

    if (_previewPath != null) File(_previewPath!).writeAsBytesSync(bytes);
  });

  test('social codes are counted by network, not as their URL type', () {
    PdfReportCode item(String type, String? social) => PdfReportCode(
          code: CodeModel(
            id: type,
            barcode: Barcode(rawValue: 'x', type: BarcodeType.url),
            date: DateTime(2026),
            source: CodeSource.scanned,
            socialMedia: social == null ? null : _social(social),
          ),
          readableType: type,
          qrPng: Uint8List(0),
        );

    final counts = countByType([
      item('URL', null),
      item('URL', null),
      item('URL', 'WhatsApp'),
    ]);

    expect(counts.standard, {'URL': 2});
    expect(counts.social, {'WhatsApp': 1});
  });
}
