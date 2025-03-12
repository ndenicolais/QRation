import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/theme/app_colors.dart';
import 'package:qration/utils/code_type_text.dart';
import 'package:qration/utils/permission_helper.dart';

class PdfService {
  final BuildContext context;
  final CodesService codesService;
  final User? currentUser;

  PdfService(this.context, this.codesService, this.currentUser);

  Future<String> generateCodesPdf(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      return await requestStoragePermission(context, () async {
        List<CodeModel> codes = await codesService.getCodesStream().first;
        codes.sort((a, b) => b.date.compareTo(a.date));

        final pdf = pw.Document();
        final customFont = await rootBundle.load("assets/fonts/Montserrat.ttf");
        final customFontBold =
            await rootBundle.load("assets/fonts/Montserrat-Bold.ttf");
        final ttf = pw.Font.ttf(customFont.buffer.asByteData());
        final ttfBold = pw.Font.ttf(customFontBold.buffer.asByteData());
        final ByteData data =
            await rootBundle.load('assets/images/app_logo.png');
        final Uint8List bytes = data.buffer.asUint8List();
        final logoImage = pw.MemoryImage(bytes);
        final appLocalizations = AppLocalizations.of(context)!;

        pdf.addPage(_buildFirstPage(logoImage, ttf));
        onProgress(0.1);
        pdf.addPage(await _buildStatsPage(codesService, currentUser, logoImage,
            ttf, ttfBold, appLocalizations));
        onProgress(0.2);

        final int totalCodes = codes.length;
        for (int i = 0; i < totalCodes; i++) {
          CodeModel code = codes[i];
          await _addCodePage(
              pdf, code, logoImage, ttf, ttfBold, appLocalizations);
          double progress = 0.2 + ((i + 1) / totalCodes) * 0.8;
          onProgress(progress);
        }

        final filePath = await _savePdf(pdf);
        onProgress(1.0);
        return filePath;
      });
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

Future<String> _savePdf(pw.Document pdf) async {
  final directory = Directory('/storage/emulated/0/Download');
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyyMMdd_HHmmss');
  final formattedDate = dateFormat.format(now);
  final filePath = '${directory.path}/qration_db_$formattedDate.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;
}

pw.TextStyle _headerTextStyle(pw.Font font) {
  return pw.TextStyle(
    color: PdfColor.fromInt(AppColors.qrBlue.value),
    font: font,
  );
}

pw.TextStyle _bodyTextStyle(pw.Font font) {
  return pw.TextStyle(
    color: PdfColor.fromInt(AppColors.qrBlue.value),
    font: font,
  );
}

pw.Page _buildFirstPage(pw.ImageProvider logoImage, pw.Font ttf) {
  return pw.Page(
    build: (pw.Context context) {
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(logoImage, height: 260, width: 260),
                pw.Text(
                  'QRation',
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                    fontSize: 80,
                  ),
                ),
              ],
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.bottomCenter,
            child: pw.Text(
              '© 2025 Nicola De Nicolais',
              style: pw.TextStyle(
                color: PdfColor.fromInt(AppColors.qrBlue.value),
                fontSize: 12,
                font: ttf,
              ),
            ),
          ),
        ],
      );
    },
  );
}

pw.Widget _buildHeader(pw.ImageProvider logoImage, pw.Font ttf) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: 1,
          color: PdfColor.fromInt(AppColors.qrGold.value),
        ),
      ),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Text(
              'QRation',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 20,
                color: PdfColor.fromInt(AppColors.qrBlue.value),
              ),
            ),
            pw.Spacer(),
            pw.Image(logoImage, height: 30, width: 30),
          ],
        ),
        pw.SizedBox(height: 10),
      ],
    ),
  );
}

Future<pw.Page> _buildStatsPage(
  final CodesService codesService,
  final User? currentUser,
  pw.ImageProvider logoImage,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) async {
  final String userId = currentUser?.uid ?? 'N/A';
  final String userName = currentUser?.displayName ?? 'N/A';
  final String userEmail = currentUser?.email ?? 'N/A';
  final String formattedCreationTime =
      DateFormat('yyyy-MM-dd').format(currentUser!.metadata.creationTime!);
  final int savedCodes = await codesService.countAllCodes();
  final int createdCodesCount =
      await codesService.countCodesBySource(CodeSource.created);
  final int scannedCodesCount =
      await codesService.countCodesBySource(CodeSource.scanned);
  final Map<String, int> socialCodesByCreated =
      await codesService.countSocialCodesByType(CodeSource.created);
  final Map<String, int> standardCodesByCreated =
      await codesService.countCodesByType(CodeSource.created);
  final Map<String, int> standardCodesByScanned =
      await codesService.countCodesByType(CodeSource.scanned);
  final Map<String, int> socialCodesByScanned =
      await codesService.countSocialCodesByType(CodeSource.scanned);

  return pw.Page(
    build: (pw.Context context) {
      final pageNumber = context.pageNumber;
      final pagesCount = context.pagesCount;
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Column(
              children: [
                _buildHeader(logoImage, ttf),
                pw.SizedBox(height: 20),
                pw.Text(
                  localizations.database_pdf_field_user_title,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrGold.value),
                    font: ttfBold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  localizations.database_pdf_field_user_id,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttfBold,
                  ),
                ),
                pw.Text(
                  userId,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  localizations.database_pdf_field_user_name,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttfBold,
                  ),
                ),
                pw.Text(
                  userName,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  localizations.database_pdf_field_user_email,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttfBold,
                  ),
                ),
                pw.Text(
                  userEmail,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  localizations.database_pdf_field_user_date,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttfBold,
                  ),
                ),
                pw.Text(
                  formattedCreationTime,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  localizations.database_pdf_field_code_title,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrGold.value),
                    font: ttfBold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  localizations.database_pdf_field_code_saved,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttfBold,
                  ),
                ),
                pw.Text(
                  '$savedCodes',
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.qrBlue.value),
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          localizations.database_pdf_field_code_created,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(AppColors.qrBlue.value),
                            font: ttfBold,
                          ),
                        ),
                        pw.Text(
                          '$createdCodesCount',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(AppColors.qrBlue.value),
                            font: ttf,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  localizations
                                      .database_pdf_field_code_created_standard,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromInt(
                                        AppColors.qrBlue.value),
                                    font: ttfBold,
                                  ),
                                ),
                                ...standardCodesByCreated.entries.map(
                                  (entry) {
                                    BarcodeType barcodeType =
                                        fromStringToBarcodeType(entry.key);
                                    CodeTypeText contentType =
                                        CodeTypeText.fromBarcodeType(
                                            barcodeType, entry.key);
                                    return pw.Text(
                                      '${contentType.type}: ${entry.value}',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(
                                            AppColors.qrBlue.value),
                                        font: ttf,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 20),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  localizations
                                      .database_pdf_field_code_created_social,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromInt(
                                        AppColors.qrBlue.value),
                                    font: ttfBold,
                                  ),
                                ),
                                ...socialCodesByCreated.entries.map(
                                  (entry) {
                                    return pw.Text(
                                      '${entry.key}: ${entry.value}',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(
                                            AppColors.qrBlue.value),
                                        font: ttf,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 60),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          localizations.database_pdf_field_code_scanned,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(AppColors.qrBlue.value),
                            font: ttfBold,
                          ),
                        ),
                        pw.Text(
                          '$scannedCodesCount',
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(AppColors.qrBlue.value),
                            font: ttf,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  localizations
                                      .database_pdf_field_code_scanned_standard,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromInt(
                                        AppColors.qrBlue.value),
                                    font: ttfBold,
                                  ),
                                ),
                                ...standardCodesByScanned.entries.map(
                                  (entry) {
                                    BarcodeType barcodeType =
                                        fromStringToBarcodeType(entry.key);
                                    CodeTypeText contentType =
                                        CodeTypeText.fromBarcodeType(
                                            barcodeType, entry.key);
                                    return pw.Text(
                                      '${contentType.type}: ${entry.value}',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(
                                            AppColors.qrBlue.value),
                                        font: ttf,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 20),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  localizations
                                      .database_pdf_field_code_scanned_social,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromInt(
                                        AppColors.qrBlue.value),
                                    font: ttfBold,
                                  ),
                                ),
                                ...socialCodesByScanned.entries.map(
                                  (entry) {
                                    return pw.Text(
                                      '${entry.key}: ${entry.value}',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(
                                            AppColors.qrBlue.value),
                                        font: ttf,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Spacer(),
                _buildFooter(pageNumber, pagesCount, ttf, localizations),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _addCodePage(
  pw.Document pdf,
  CodeModel code,
  pw.MemoryImage logoImage,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) async {
  final qrValidationResult = QrValidator.validate(
    data: code.barcode.rawValue ?? '',
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.M,
  );
  final qrCode = qrValidationResult.qrCode;

  final painter = QrPainter.withQr(
    qr: qrCode!,
    eyeStyle: QrEyeStyle(
      eyeShape: code.eyeRounded == 1 ? QrEyeShape.circle : QrEyeShape.square,
      color: code.eyeColor,
    ),
    dataModuleStyle: QrDataModuleStyle(
      dataModuleShape: code.moduleRounded == 1
          ? QrDataModuleShape.circle
          : QrDataModuleShape.square,
      color: code.moduleColor,
    ),
  );

  final image = await painter.toImageData(220);

  String formattedDate = DateFormat('yyyy-MM-dd').format(code.date);
  var readableType = CodeTypeText.fromBarcodeType(
    fromStringToBarcodeType(code.barcode.type.toString().split('.').last),
    code.barcode.type.toString().split('.').last,
  ).type;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        final pageNumber = context.pageNumber;
        final pagesCount = context.pagesCount;
        return pw.Column(
          children: [
            _buildHeader(logoImage, ttf),
            pw.SizedBox(height: 20),
            pw.Text(localizations.database_service_codes_field_id,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.id, style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_date,
                style: _headerTextStyle(ttfBold)),
            pw.Text(formattedDate, style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_source,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.source.toString().split('.').last,
                style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_type,
                style: _headerTextStyle(ttfBold)),
            pw.Text(readableType, style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_code,
                style: _headerTextStyle(ttfBold)),
            pw.SizedBox(height: 4),
            pw.Image(
              pw.MemoryImage(image!.buffer.asUint8List()),
              width: 100,
              height: 100,
            ),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_content,
                style: _headerTextStyle(ttfBold)),
            pw.Container(
              width: 340,
              child: pw.Text(
                code.barcode.rawValue ?? '',
                style: _bodyTextStyle(ttf),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_eye_color,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.eyeColor.value.toRadixString(16),
                style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_eye_rounded,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.eyeRounded.toString(), style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_module_color,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.moduleColor.value.toRadixString(16),
                style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_module_rounded,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.moduleRounded.toString(), style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_favorite,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.isFavorite.toString(), style: _bodyTextStyle(ttf)),
            pw.SizedBox(height: 10),
            pw.Text(localizations.database_service_codes_field_social,
                style: _headerTextStyle(ttfBold)),
            pw.Text(code.socialMedia?.name ?? '-', style: _bodyTextStyle(ttf)),
            pw.Spacer(),
            _buildFooter(pageNumber, pagesCount, ttf, localizations),
          ],
        );
      },
    ),
  );
}

pw.Widget _buildFooter(int pageNumber, int pagesCount, pw.Font ttf,
    AppLocalizations localizations) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(
          width: 1,
          color: PdfColor.fromInt(AppColors.qrGold.value),
        ),
      ),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          '${localizations.database_pdf_page} $pageNumber of $pagesCount',
          style: pw.TextStyle(
            font: ttf,
            fontSize: 12,
            color: PdfColor.fromInt(AppColors.qrBlue.value),
          ),
        ),
      ],
    ),
  );
}
