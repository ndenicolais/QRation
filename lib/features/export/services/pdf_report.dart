// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:typed_data';

import 'package:flutter/painting.dart' show Color;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Everything the PDF export shows, already fetched and resolved, so the
/// layout ([buildPdfReport]) has no Firebase or Flutter dependencies.
class PdfReportData {
  const PdfReportData({
    required this.exportedAt,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.accountCreatedAt,
    required this.createdByType,
    required this.scannedByType,
    required this.codes,
  });

  final DateTime exportedAt;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime? accountCreatedAt;

  /// Counts per readable type ("URL", "Wi-Fi", "Instagram"…), split into
  /// standard and social, for created and scanned codes.
  final PdfTypeCounts createdByType;
  final PdfTypeCounts scannedByType;

  /// Newest first.
  final List<PdfReportCode> codes;

  int get createdCount => codes.where((c) => c.isCreated).length;
  int get scannedCount => codes.length - createdCount;
}

class PdfTypeCounts {
  const PdfTypeCounts({this.standard = const {}, this.social = const {}});

  final Map<String, int> standard;
  final Map<String, int> social;

  bool get isEmpty => standard.isEmpty && social.isEmpty;
}

/// One code row: the model plus what the layout cannot compute itself.
class PdfReportCode {
  const PdfReportCode({
    required this.code,
    required this.readableType,
    required this.qrPng,
  });

  final CodeModel code;
  final String readableType;
  final Uint8List qrPng;

  bool get isCreated => code.source == CodeSource.created;

  /// The generic "Link" fallback of URL codes is not a social network.
  String? get socialName {
    final name = code.socialMedia?.name;
    return name == null || name == 'Link' ? null : name;
  }
}

/// Fonts and images shared by every page.
class PdfReportAssets {
  const PdfReportAssets({
    required this.regular,
    required this.bold,
    required this.logo,
  });

  final pw.Font regular;
  final pw.Font bold;
  final pw.ImageProvider logo;
}

PdfColor _pdf(Color color) => PdfColor.fromInt(color.toARGB32());

final _navy = _pdf(AppColors.qrBlue);
final _gold = _pdf(AppColors.qrGold);
final _goldSoft = PdfColor.fromHex('#F6EEE3');
final _navySoft = PdfColor.fromHex('#E8EFF7');
final _secondary = _pdf(AppColors.textSecondaryLight);
final _divider = _pdf(AppColors.dividerLight);
final _card = _pdf(AppColors.cardLight);

/// Builds the export: a cover, then account, statistics and one card per
/// code, flowing several codes per page.
pw.Document buildPdfReport({
  required PdfReportData data,
  required PdfReportAssets assets,
  required AppLocalizations l10n,
}) {
  final theme =
      pw.ThemeData.withFont(base: assets.regular, bold: assets.bold).copyWith(
    defaultTextStyle: pw.TextStyle(
      font: assets.regular,
      fontBold: assets.bold,
      fontSize: 10,
      color: _navy,
    ),
  );
  final doc = pw.Document(
    theme: theme,
    title: 'QRation',
    author: data.userName,
    creator: 'QRation',
  );
  final pageFormat = PdfPageFormat.a4.copyWith(
    marginLeft: 40,
    marginRight: 40,
    marginTop: 36,
    marginBottom: 36,
  );

  doc.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (_) => _cover(data, assets, l10n),
    ),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      header: (_) => _header(assets),
      footer: (context) => _footer(
        l10n.pdf_report_page(context.pageNumber, context.pagesCount),
      ),
      build: (_) => [
        _sectionTitle(l10n.database_pdf_field_user_title),
        _accountTable(data, l10n),
        pw.SizedBox(height: 22),
        _sectionTitle(l10n.database_pdf_field_code_title),
        _statTiles(data, l10n),
        pw.SizedBox(height: 10),
        _typeBreakdown(data, l10n),
        pw.SizedBox(height: 22),
        _sectionTitle(
          '${l10n.pdf_report_codes} (${data.codes.length})',
        ),
        for (final code in data.codes) _codeCard(code, l10n),
      ],
    ),
  );

  doc.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (_) => _closing(data, assets, l10n),
    ),
  );
  return doc;
}

pw.Widget _cover(
  PdfReportData data,
  PdfReportAssets assets,
  AppLocalizations l10n,
) {
  // Full width, so the centered column is centered on the page.
  return pw.SizedBox(
    width: double.infinity,
    child: pw.Column(
      children: [
        pw.Spacer(flex: 2),
        pw.Image(assets.logo, width: 120, height: 120),
        pw.SizedBox(height: 18),
        pw.Text('QRation', style: pw.TextStyle(fontSize: 40, color: _navy)),
        pw.SizedBox(height: 6),
        pw.Text(
          l10n.pdf_report_subtitle,
          style: pw.TextStyle(fontSize: 14, color: _secondary),
        ),
        pw.SizedBox(height: 22),
        pw.Container(width: 56, height: 2, color: _gold),
        pw.SizedBox(height: 22),
        pw.Text(
          data.userName,
          style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(data.userEmail, style: pw.TextStyle(color: _secondary)),
        pw.SizedBox(height: 18),
        _chip(l10n.pdf_report_codes_count(data.codes.length),
            background: _navySoft),
        pw.Spacer(flex: 3),
      ],
    ),
  );
}

/// Last page: who made the app, how to reach them and the copyright.
pw.Widget _closing(
  PdfReportData data,
  PdfReportAssets assets,
  AppLocalizations l10n,
) {
  final secondary = pw.TextStyle(color: _secondary);
  return pw.SizedBox(
    width: double.infinity,
    child: pw.Column(
      children: [
        pw.Spacer(),
        pw.Image(assets.logo, width: 64, height: 64),
        pw.SizedBox(height: 12),
        pw.Text('QRation', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 18),
        pw.Container(width: 56, height: 2, color: _gold),
        pw.SizedBox(height: 18),
        pw.Text(
          l10n.info_screen_made_by(AppConstants.developerName),
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(AppConstants.developerEmail, style: secondary),
        pw.SizedBox(height: 2),
        pw.Text(AppConstants.uriGithubLink.host, style: secondary),
        pw.Spacer(),
        pw.Text(
          '© ${data.exportedAt.year} ${AppConstants.developerName}. '
          '${l10n.pdf_report_rights}',
          style: pw.TextStyle(fontSize: 9, color: _secondary),
        ),
      ],
    ),
  );
}

pw.Widget _header(PdfReportAssets assets) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 18),
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _gold, width: 1)),
    ),
    child: pw.Row(
      children: [
        pw.Image(assets.logo, width: 18, height: 18),
        pw.SizedBox(width: 8),
        pw.Text('QRation', style: pw.TextStyle(fontSize: 13)),
      ],
    ),
  );
}

pw.Widget _footer(String page) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 12),
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: _divider, width: 1)),
    ),
    child: pw.Row(
      children: [
        pw.Text('QRation', style: pw.TextStyle(fontSize: 9, color: _secondary)),
        pw.Spacer(),
        pw.Text(page, style: pw.TextStyle(fontSize: 9, color: _secondary)),
      ],
    ),
  );
}

pw.Widget _sectionTitle(String title) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 10),
    padding: const pw.EdgeInsets.only(left: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(left: pw.BorderSide(color: _gold, width: 3)),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
    ),
  );
}

pw.Widget _accountTable(PdfReportData data, AppLocalizations l10n) {
  final created = data.accountCreatedAt;
  final rows = [
    (l10n.database_pdf_field_user_name, data.userName),
    (l10n.database_pdf_field_user_email, data.userEmail),
    if (created != null)
      (
        l10n.database_pdf_field_user_date,
        DateFormat.yMMMMd(l10n.localeName).format(created),
      ),
    (l10n.database_pdf_field_user_id, data.userId),
  ];
  return _box(
    pw.Column(
      children: [
        for (var i = 0; i < rows.length; i++)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            decoration: i == rows.length - 1
                ? null
                : pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: _divider, width: 0.5),
                    ),
                  ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 120,
                  child: pw.Text(rows[i].$1,
                      style: pw.TextStyle(color: _secondary)),
                ),
                pw.Expanded(child: pw.Text(rows[i].$2)),
              ],
            ),
          ),
      ],
    ),
  );
}

pw.Widget _statTiles(PdfReportData data, AppLocalizations l10n) {
  pw.Widget tile(String label, int value, PdfColor accent) => pw.Expanded(
        child: _box(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(width: 18, height: 3, color: accent),
              pw.SizedBox(height: 8),
              pw.Text('$value',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text(label, style: pw.TextStyle(color: _secondary)),
            ],
          ),
        ),
      );
  return pw.Row(
    children: [
      tile(l10n.database_pdf_field_code_saved, data.codes.length, _navy),
      pw.SizedBox(width: 10),
      tile(l10n.database_pdf_field_code_created, data.createdCount, _gold),
      pw.SizedBox(width: 10),
      tile(l10n.database_pdf_field_code_scanned, data.scannedCount,
          _pdf(AppColors.qrBlueLight)),
    ],
  );
}

pw.Widget _typeBreakdown(PdfReportData data, AppLocalizations l10n) {
  pw.Widget column(String title, PdfTypeCounts counts) {
    pw.Widget group(String label, Map<String, int> values) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 6),
            pw.Text(label.toUpperCase(),
                style: pw.TextStyle(
                    fontSize: 8, color: _secondary, letterSpacing: 0.6)),
            for (final entry in values.entries)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3),
                child: pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text(entry.key)),
                    pw.Text('${entry.value}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
          ],
        );
    return pw.Expanded(
      child: _box(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            if (counts.isEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 6),
                child: pw.Text(l10n.pdf_report_none,
                    style: pw.TextStyle(color: _secondary)),
              ),
            if (counts.standard.isNotEmpty)
              group(l10n.database_pdf_field_code_created_standard,
                  counts.standard),
            if (counts.social.isNotEmpty)
              group(l10n.database_pdf_field_code_created_social, counts.social),
          ],
        ),
      ),
    );
  }

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      column(l10n.database_pdf_field_code_created, data.createdByType),
      pw.SizedBox(width: 10),
      column(l10n.database_pdf_field_code_scanned, data.scannedByType),
    ],
  );
}

pw.Widget _codeCard(PdfReportCode item, AppLocalizations l10n) {
  final code = item.code;
  final date = DateFormat('dd/MM/yyyy HH:mm').format(code.date);
  final notes = code.notes?.trim() ?? '';
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 10),
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _card,
      border: pw.Border.all(color: _divider, width: 1),
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 92,
          height: 92,
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Image(pw.MemoryImage(item.qrPng)),
        ),
        pw.SizedBox(width: 14),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _chip(item.readableType, background: _navySoft),
                  _chip(
                    item.isCreated ? l10n.tab_created : l10n.tab_scanned,
                    background: _goldSoft,
                  ),
                  if (item.socialName != null)
                    _chip(item.socialName!, background: _navySoft),
                  if (code.isFavorite)
                    _chip(l10n.database_service_codes_field_favorite,
                        background: _gold, color: PdfColors.white),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                code.barcode.rawValue ?? '',
                style: pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
              ),
              pw.SizedBox(height: 6),
              pw.Text(date,
                  style: pw.TextStyle(fontSize: 9, color: _secondary)),
              if (notes.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  '${l10n.pdf_report_notes}: $notes',
                  style: pw.TextStyle(fontSize: 9, color: _secondary),
                ),
              ],
              if (item.isCreated) ...[
                pw.SizedBox(height: 6),
                _styleLine(code, l10n),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

/// "Eyes ● #274060 rounded · Modules ● #000000 square"
pw.Widget _styleLine(CodeModel code, AppLocalizations l10n) {
  final small = pw.TextStyle(fontSize: 9, color: _secondary);
  List<pw.Widget> part(String label, Color color, int rounded) => [
        pw.Text('$label ', style: small),
        pw.Container(
          width: 8,
          height: 8,
          decoration: pw.BoxDecoration(
            color: _pdf(color),
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: _divider, width: 0.5),
          ),
        ),
        pw.Text(
          ' #${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}'
          ' ${rounded == 1 ? l10n.pdf_report_rounded : l10n.pdf_report_square}',
          style: small,
        ),
      ];
  return pw.Row(
    children: [
      ...part(l10n.pdf_report_eyes, code.eyeColor, code.eyeRounded),
      pw.Text('   ·   ', style: small),
      ...part(l10n.pdf_report_modules, code.moduleColor, code.moduleRounded),
    ],
  );
}

pw.Widget _chip(String text, {required PdfColor background, PdfColor? color}) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: pw.BoxDecoration(
      color: background,
      borderRadius: pw.BorderRadius.circular(10),
    ),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 9, color: color)),
  );
}

pw.Widget _box(pw.Widget child) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _card,
      border: pw.Border.all(color: _divider, width: 1),
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: child,
  );
}
