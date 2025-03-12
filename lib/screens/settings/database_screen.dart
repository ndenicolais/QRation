import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/services/excel_service.dart';
import 'package:qration/services/csv_service.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/services/pdf_service.dart';
import 'package:qration/widgets/custom_loader.dart';
import 'package:qration/widgets/custom_toast.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  DatabaseScreenState createState() => DatabaseScreenState();
}

class DatabaseScreenState extends State<DatabaseScreen>
    with TickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final CodesService _codesService = CodesService();
  late final PdfService _pdfService;
  late final ExcelService _excelService;
  late final CSVService _csvService;
  late AnimationController _loadingController;
  bool _isLoading = true;
  late AnimationController _loadingPdfController;
  bool _isFileLoading = false;
  bool _isJSONLoading = false;
  double _downloadProgress = 0.0;
  int? _totalCodes;
  int? _createdCodesCount;
  int? _scannedCodesCount;
  Map<String, int>? _standardCodesByCreated;
  Map<String, int>? _socialCodesByCreated;
  Map<String, int>? _standardCodesByScanned;
  Map<String, int>? _socialCodesByScanned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(30.r),
              child: _isLoading
                  ? _buildLoadingIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAccountInfo(context),
                          _buildTotalCodesCard(context),
                          _buildCodeSources(context),
                          _buildExportButtons(context),
                        ],
                      ),
                    ),
            ),
            if (_isFileLoading)
              Positioned.fill(
                child: _buildFileLoading(context),
              ),
            if (_isJSONLoading)
              Positioned.fill(
                child: _buildJSONLoading(context),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pdfService = PdfService(context, _codesService, currentUser);
    _excelService = ExcelService(context, _codesService, currentUser);
    _csvService = CSVService(context, _codesService, currentUser);
    _loadData();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _loadingPdfController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  Future<void> _loadData() async {
    final totalCodes = await _codesService.countAllCodes();
    final createdCodesCount =
        await _codesService.countCodesBySource(CodeSource.created);
    final scannedCodesCount =
        await _codesService.countCodesBySource(CodeSource.scanned);
    final standardCodesByCreated =
        await _codesService.countCodesByType(CodeSource.created);
    final socialCodesByCreated =
        await _codesService.countSocialCodesByType(CodeSource.created);
    final standardCodesByScanned =
        await _codesService.countCodesByType(CodeSource.scanned);
    final socialCodesByScanned =
        await _codesService.countSocialCodesByType(CodeSource.scanned);

    setState(() {
      _isLoading = false;
      _totalCodes = totalCodes;
      _createdCodesCount = createdCodesCount;
      _scannedCodesCount = scannedCodesCount;
      _standardCodesByCreated = standardCodesByCreated;
      _socialCodesByCreated = socialCodesByCreated;
      _standardCodesByScanned = standardCodesByScanned;
      _socialCodesByScanned = socialCodesByScanned;
    });
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isFileLoading = true;
      _downloadProgress = 0.0;
    });

    try {
      final filePath = await _pdfService.generateCodesPdf(context, (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.database_screen_pdf_confirm,
        );
      }
      await _sharePdf(filePath);
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.database_screen_pdf_error,
        );
      }
    } finally {
      setState(() {
        _isFileLoading = false;
      });
    }
  }

  Future<void> _generateExcel() async {
    setState(() {
      _isFileLoading = true;
      _downloadProgress = 0.0;
    });

    try {
      final filePath = await _excelService.generateExcel(context, (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.database_screen_excel_confirm,
        );
      }
      await _shareExcel(filePath);
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.database_screen_excel_error,
        );
      }
    } finally {
      setState(() {
        _isFileLoading = false;
      });
    }
  }

  Future<void> _generateCSV() async {
    setState(() {
      _isFileLoading = true;
      _downloadProgress = 0.0;
    });

    try {
      final filePath = await _csvService.generateCSV(context, (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.database_screen_csv_confirm,
        );
      }
      await _shareCSV(filePath);
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.database_screen_csv_error,
        );
      }
    } finally {
      setState(() {
        _isFileLoading = false;
      });
    }
  }

  Future<void> _sharePdf(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile]);
  }

  Future<void> _shareExcel(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile]);
  }

  Future<void> _shareCSV(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile]);
  }

  Future<void> _exportCodes() async {
    setState(() {
      _isJSONLoading = true;
    });

    try {
      final jsonCodes = await _codesService.exportCodesToJson();
      final directory = Directory('/storage/emulated/0/Download');
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyyMMdd_HHmmss');
      final formattedDate = dateFormat.format(now);
      final filePath = '${directory.path}/qration_db_$formattedDate.json';
      final file = File(filePath);
      await file.writeAsString(jsonCodes);
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.database_screen_export_success,
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.database_screen_export_error} $e',
        );
      }
    } finally {
      setState(() {
        _isJSONLoading = false;
      });
    }
  }

  Future<void> _importCodes() async {
    setState(() {
      _isJSONLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String jsonCodes = await file.readAsString();
        await _codesService.importCodesFromJson(jsonCodes);
        if (mounted) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.database_screen_import_success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          '${AppLocalizations.of(context)!.database_screen_import_error} $e',
        );
      }
    } finally {
      setState(() {
        _isJSONLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _loadingPdfController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        AppLocalizations.of(context)!.database_screen_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(
        MingCuteIcons.mgc_more_2_fill,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSelected: (String result) {
        switch (result) {
          case 'export':
            _exportCodes();
            break;
          case 'import':
            _importCodes();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupMenuItem(
          context,
          'export',
          MingCuteIcons.mgc_file_export_line,
          AppLocalizations.of(context)!.database_screen_export_menu,
        ),
        _buildPopupMenuItem(
          context,
          'import',
          MingCuteIcons.mgc_file_import_line,
          AppLocalizations.of(context)!.database_screen_import_menu,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: CustomLoader(
        width: 50.w,
        height: 50.h,
      ),
    );
  }

  Widget _buildFileLoadingIndicator(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: CircularProgressIndicator(
                value: _downloadProgress,
                strokeWidth: 4.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              '${(_downloadProgress * 100).toStringAsFixed(0)}%',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildFileLoadingIndicator(context)),
    );
  }

  Widget _buildJSONLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildLoadingIndicator(context)),
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    String formattedCreationTime = currentUser!.metadata.creationTime != null
        ? '${currentUser!.metadata.creationTime!.day}/${currentUser!.metadata.creationTime!.month}/${currentUser!.metadata.creationTime!.year}'
        : 'Unknown';

    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.database_screen_account_title,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.tertiary),
            Text(
              AppLocalizations.of(context)!
                  .database_screen_account_field_userid,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              currentUser!.uid,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.database_screen_account_field_name,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              currentUser!.displayName ?? 'N/A',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.database_screen_account_field_email,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              currentUser!.email ?? 'N/A',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.database_screen_account_field_date,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              formattedCreationTime,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCodesCard(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .database_screen_codes_field_total_title,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.tertiary),
            Text(
              AppLocalizations.of(context)!
                  .database_screen_codes_field_total_saved,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
              ),
            ),
            Text(
              '${_totalCodes ?? 0}',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeSources(BuildContext context) {
    return Column(
      children: [
        _buildCodesCard(
            context,
            AppLocalizations.of(context)!
                .database_screen_codes_field_created_title,
            CodeSource.created,
            MingCuteIcons.mgc_qrcode_fill,
            _createdCodesCount),
        _buildCodesCard(
            context,
            AppLocalizations.of(context)!
                .database_screen_codes_field_scanned_title,
            CodeSource.scanned,
            MingCuteIcons.mgc_scan_fill,
            _scannedCodesCount),
      ],
    );
  }

  Widget _buildCodesCard(BuildContext context, String title, CodeSource source,
      IconData icon, int? count) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodesCount(context, title, icon, count),
            _buildStandardCodesTile(context, source),
            _buildSocialCodesTile(context, source),
          ],
        ),
      ),
    );
  }

  Widget _buildCodesCount(
    BuildContext context,
    String title,
    IconData icon,
    int? count,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        Divider(color: Theme.of(context).colorScheme.tertiary),
        Text(
          AppLocalizations.of(context)!
              .database_screen_codes_field_created_totals,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
          ),
        ),
        Text(
          '${count ?? 0}',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStandardCodesTile(BuildContext context, CodeSource source) {
    final standardCounts = source == CodeSource.created
        ? _standardCodesByCreated
        : _standardCodesByScanned;

    if (standardCounts == null) {
      return _buildLoadingIndicator(context);
    }

    if (standardCounts.isEmpty) {
      return ListTile(
        title: Text(
          AppLocalizations.of(context)!.database_screen_codes_field_empty,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return ListTile(
      title: Text(
        AppLocalizations.of(context)!
            .database_screen_codes_field_standard_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Icon(
        MingCuteIcons.mgc_right_fill,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        _showCodesDialog(
            context,
            AppLocalizations.of(context)!.database_screen_codes_dialog_standard,
            standardCounts);
      },
    );
  }

  Widget _buildSocialCodesTile(BuildContext context, CodeSource source) {
    final socialMediaCounts = source == CodeSource.created
        ? _socialCodesByCreated
        : _socialCodesByScanned;

    if (socialMediaCounts == null) {
      return _buildLoadingIndicator(context);
    }

    if (socialMediaCounts.isEmpty) {
      return ListTile(
        title: Text(
          AppLocalizations.of(context)!.database_screen_codes_field_empty,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.database_screen_codes_field_social_title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Icon(
        MingCuteIcons.mgc_right_fill,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        _showCodesDialog(
            context,
            AppLocalizations.of(context)!.database_screen_codes_dialog_social,
            socialMediaCounts);
      },
    );
  }

  void _showCodesDialog(
      BuildContext context, String title, Map<String, int> counts) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            title,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: counts.entries.map(
              (entry) {
                return Text(
                  '${entry.key}: ${entry.value}',
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16.sp,
                  ),
                );
              },
            ).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!
                    .database_screen_codes_dialog_close,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportCard(
    BuildContext context,
    IconData iconData,
    String text,
    VoidCallback onTap,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 40.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              SizedBox(height: 10.h),
              Text(
                text,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButtons(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.database_screen_export_title,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.tertiary),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildExportCard(
                  context,
                  LineAwesomeIcons.file_pdf_solid,
                  AppLocalizations.of(context)!.database_screen_pdf_download,
                  () async {
                    _generatePdf();
                  },
                ),
                _buildExportCard(
                  context,
                  LineAwesomeIcons.file_excel_solid,
                  AppLocalizations.of(context)!.database_screen_excel_download,
                  () async {
                    _generateExcel();
                  },
                ),
                _buildExportCard(
                  context,
                  LineAwesomeIcons.file_csv_solid,
                  AppLocalizations.of(context)!.database_screen_csv_download,
                  () async {
                    _generateCSV();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
