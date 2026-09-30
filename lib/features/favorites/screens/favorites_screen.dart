// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/utils/code_type_icon.dart';
import 'package:qration/core/utils/code_type_body.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/screens/code_details_screen.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_empty_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late final FavoritesController _controller;
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    _controller = Get.put(FavoritesController());
  }

  @override
  void dispose() {
    Get.delete<FavoritesController>();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    return TabBar(
      controller: _tabController,
      indicator: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      indicatorPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      splashBorderRadius: BorderRadius.circular(14),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return theme.colorScheme.primary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return theme.colorScheme.primary.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      }),
      labelColor: theme.colorScheme.primary,
      labelStyle: AppFonts.montserrat(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      unselectedLabelStyle: AppFonts.montserrat(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      dividerColor: Colors.transparent,
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
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final error = _controller.error.value;
      if (error != null) {
        return AppErrorState(
          title:
              '${AppLocalizations.of(context)!.favorites_screen_error_state} $error',
        );
      }

      if (!_controller.hasFavorites.value) {
        return AppEmptyState(
          icon: MingCuteIcons.mgc_inbox_2_fill,
          message: AppLocalizations.of(context)!.favorites_screen_empty_state,
        );
      }

      return TabBarView(
        controller: _tabController,
        children: [
          _buildCodesList(
            context,
            _controller.createdCodes.toList(),
            CodeSource.created,
          ),
          _buildCodesList(
            context,
            _controller.scannedCodes.toList(),
            CodeSource.scanned,
          ),
        ],
      );
    });
  }

  Widget _buildCodesList(
      BuildContext context, List<CodeModel> filteredCodes, CodeSource source) {
    if (filteredCodes.isEmpty) {
      return AppEmptyState(
        icon: source == CodeSource.created
            ? MingCuteIcons.mgc_qrcode_fill
            : MingCuteIcons.mgc_scan_fill,
        message: AppLocalizations.of(context)!.favorites_screen_empty_state,
      );
    }

    return ListView.builder(
      itemCount: filteredCodes.length,
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 16.h),
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
      color: Theme.of(context).cardTheme.color,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1.w,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        leading: Icon(
          contentIcon.icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayContent,
              style: AppFonts.montserrat(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
          ],
        ),
        subtitle: Text(
          formattedDate,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
          ),
        ),
        trailing: IconButton(
          tooltip: AppLocalizations.of(context)!.history_screen_tooltip_details,
          icon: Icon(
            MingCuteIcons.mgc_right_fill,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
