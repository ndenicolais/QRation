// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/export/services/csv_service.dart';
import 'package:qration/features/export/services/excel_service.dart';
import 'package:qration/features/export/services/pdf_service.dart';
import 'package:qration/features/settings/controllers/database_controller.dart';
import 'package:qration/features/settings/widgets/backup_section.dart';
import 'package:qration/features/settings/widgets/export_section.dart';
import 'package:qration/features/settings/widgets/loading_overlays.dart';
import 'package:qration/features/settings/widgets/statistics_section.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  DatabaseScreenState createState() => DatabaseScreenState();
}

class DatabaseScreenState extends State<DatabaseScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseController _controller = Get.find<DatabaseController>();

  @override
  void initState() {
    super.initState();
    final codesService = Get.find<CodesRepository>();
    final pdfService = PdfService(context, codesService, currentUser);
    final excelService = ExcelService(context, codesService, currentUser);
    final csvService = CSVService(context, codesService, currentUser);
    _controller.attachServices(pdfService, excelService, csvService);
  }

  Future<void> _shareFile(String? filePath) async {
    if (filePath == null) return;
    await Share.shareXFiles([XFile(filePath)]);
  }

  Future<void> _generatePdf() async {
    final l10n = AppLocalizations.of(context)!;
    final filePath = await _controller.generatePdf(context);
    if (!mounted) return;
    if (filePath != null) {
      showSuccessToast(context, l10n.database_screen_pdf_confirm);
      await _shareFile(filePath);
    } else {
      showErrorToast(context, l10n.database_screen_pdf_error);
    }
  }

  Future<void> _generateExcel() async {
    final l10n = AppLocalizations.of(context)!;
    final filePath = await _controller.generateExcel(context);
    if (!mounted) return;
    if (filePath != null) {
      showSuccessToast(context, l10n.database_screen_excel_confirm);
      await _shareFile(filePath);
    } else {
      showErrorToast(context, l10n.database_screen_excel_error);
    }
  }

  Future<void> _generateCSV() async {
    final l10n = AppLocalizations.of(context)!;
    final filePath = await _controller.generateCSV(context);
    if (!mounted) return;
    if (filePath != null) {
      showSuccessToast(context, l10n.database_screen_csv_confirm);
      await _shareFile(filePath);
    } else {
      showErrorToast(context, l10n.database_screen_csv_error);
    }
  }

  Future<void> _exportCodes() async {
    final l10n = AppLocalizations.of(context)!;
    final success = await _controller.exportCodes();
    if (!mounted) return;
    if (success) {
      showSuccessToast(context, l10n.database_screen_export_success);
    } else {
      showErrorToast(
        context,
        '${l10n.database_screen_export_error} ${_controller.lastError}',
      );
    }
  }

  Future<void> _importCodes() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _controller.importCodes();
    if (!mounted) return;
    switch (result) {
      case ImportResult.success:
        showSuccessToast(context, l10n.database_screen_import_success);
        break;
      case ImportResult.cancelled:
        break;
      case ImportResult.error:
        showErrorToast(
          context,
          '${l10n.database_screen_import_error} ${_controller.lastError}',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              _controller.isLoading.value
                  ? const LoadingIndicator()
                  : _controller.hasError.value
                      ? AppErrorState(
                          title: l10n.database_screen_load_error,
                          onRetry: _controller.loadData,
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(16, 24, 16, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatisticsSection(
                                totalCodes: _controller.totalCodes.value,
                                createdCodesCount:
                                    _controller.createdCodesCount.value,
                                scannedCodesCount:
                                    _controller.scannedCodesCount.value,
                                standardCodesByCreated:
                                    _controller.standardCodesByCreated.value,
                                socialCodesByCreated:
                                    _controller.socialCodesByCreated.value,
                                standardCodesByScanned:
                                    _controller.standardCodesByScanned.value,
                                socialCodesByScanned:
                                    _controller.socialCodesByScanned.value,
                              ),
                              SizedBox(height: 28),
                              BackupSection(
                                lastExportAt: _controller.lastExportAt.value,
                                lastImportAt: _controller.lastImportAt.value,
                              ),
                              SizedBox(height: 28),
                              ExportSection(
                                onPdf: _generatePdf,
                                onExcel: _generateExcel,
                                onCsv: _generateCSV,
                              ),
                            ],
                          ),
                        ),
              if (_controller.isFileLoading.value)
                Positioned.fill(
                  child: FileLoadingOverlay(
                    downloadProgress: _controller.downloadProgress.value,
                  ),
                ),
              if (_controller.isJsonLoading.value)
                Positioned.fill(child: const JsonLoadingOverlay()),
            ],
          ),
        ),
      ),
    );
  }

  // Colors and title style come from the theme appBarTheme.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
        onPressed: Get.back,
      ),
      title: Text(AppLocalizations.of(context)!.database_screen_title),
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context)!.database_screen_import_menu,
          icon: const Icon(MingCuteIcons.mgc_file_import_line),
          onPressed: _importCodes,
        ),
        IconButton(
          tooltip: AppLocalizations.of(context)!.database_screen_export_menu,
          icon: const Icon(MingCuteIcons.mgc_file_export_line),
          onPressed: _exportCodes,
        ),
        SizedBox(width: 4),
      ],
    );
  }
}
