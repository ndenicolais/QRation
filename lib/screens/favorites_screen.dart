import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/utils/code_type_icon.dart';
import 'package:qration/utils/code_type_body.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/screens/codes/code_details_screen.dart';
import 'package:qration/services/codes_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  final CodesService _codesService = CodesService();
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: _buildTabBarView(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      indicatorColor: Theme.of(context).colorScheme.tertiary,
      indicatorWeight: 8.w,
      labelColor: Theme.of(context).colorScheme.tertiary,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: Theme.of(context).colorScheme.secondary,
      unselectedLabelStyle: GoogleFonts.montserrat(
        fontSize: 16.sp,
      ),
      tabs: [
        _buildTab(
          icon: MingCuteIcons.mgc_qrcode_fill,
          text: AppLocalizations.of(context)!.favorites_screen_tab_created,
        ),
        _buildTab(
          icon: MingCuteIcons.mgc_scan_fill,
          text: AppLocalizations.of(context)!.favorites_screen_tab_scanned,
        ),
      ],
    );
  }

  Widget _buildTab({required IconData icon, required String text}) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: 8.w),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: _codesService.getFavoriteCodesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context, CodeSource.created);
        }

        final List<CodeModel> favoriteCodes = snapshot.data!;

        return TabBarView(
          controller: _tabController,
          children: [
            _buildCodesList(
              context,
              favoriteCodes,
              CodeSource.created,
            ),
            _buildCodesList(
              context,
              favoriteCodes,
              CodeSource.scanned,
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    return Center(
      child: SizedBox(
        width: 320.w,
        child: Text(
          '${AppLocalizations.of(context)!.favorites_screen_error_state} $error',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CodeSource source) {
    return Center(
      child: SizedBox(
        width: 320.w,
        child: Text(
          AppLocalizations.of(context)!.favorites_screen_empty_state,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 22.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCodesList(
      BuildContext context, List<CodeModel> favoriteCodes, CodeSource source) {
    final List<CodeModel> filteredCodes =
        favoriteCodes.where((CodeModel code) => code.source == source).toList();

    filteredCodes.sort((a, b) => b.date.compareTo(a.date));

    if (filteredCodes.isEmpty) {
      return _buildEmptyState(context, source);
    }

    return ListView.builder(
      itemCount: filteredCodes.length,
      itemBuilder: (context, index) {
        final code = filteredCodes[index];
        return CodeCard(
          code: code,
          onTap: () async {
            await Get.to(
              () => CodeDetailsScreen(code: code),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}

class CodeCard extends StatelessWidget {
  final CodeModel code;
  final VoidCallback onTap;

  const CodeCard({super.key, required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final DateTime date = code.date;
    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
    final contentIcon = CodeTypeIcon.fromBarcodeType(
        code.barcode.type, code.barcode.rawValue ?? '');
    final contentFormatter = getContentBody(code);
    final displayContent = contentFormatter.formattedContent;

    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: EdgeInsets.all(8.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.w,
        ),
      ),
      child: ListTile(
        leading: Icon(
          contentIcon.icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayContent,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
          ],
        ),
        subtitle: Text(
          formattedDate,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12.sp,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_right_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
