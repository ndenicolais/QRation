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
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/widgets/code_list_tile.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_empty_state.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/sync_status_banner.dart';
import 'package:qration/core/widgets/app_loader.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, this.onCreateCode});

  /// Empty-state call to action (e.g. switch Home to the Create tab).
  final VoidCallback? onCreateCode;

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
    _controller = Get.find<FavoritesController>();
  }

  @override
  void dispose() {
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
      // Sized on the whole tab: with the default `label` size the horizontal
      // padding shrank the pill to the middle of the icon + text pair.
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      unselectedLabelStyle: AppFonts.montserrat(
        fontSize: 14,
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
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    final ok = await _controller.refreshCodes();
    if (!ok && mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.sync_refresh_offline,
      );
    }
  }

  Widget _buildTabBarView(BuildContext context) {
    return Column(
      children: [
        Obx(() => SyncStatusBanner(status: _controller.syncStatus.value)),
        Expanded(child: _buildTabContent(context)),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: AppLoader());
      }

      final error = _controller.error.value;
      if (error != null) {
        return AppErrorState(
          title:
              '${AppLocalizations.of(context)!.favorites_screen_error_state} $error',
        );
      }

      if (!_controller.hasFavorites.value) {
        return RefreshIndicator(
          onRefresh: _refresh,
          child: PullToRefreshFill(
            child: AppEmptyState(
              icon: MingCuteIcons.mgc_inbox_2_fill,
              message:
                  AppLocalizations.of(context)!.favorites_screen_empty_state,
              actionLabel:
                  AppLocalizations.of(context)!.favorites_screen_empty_action,
              onAction: widget.onCreateCode,
            ),
          ),
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
    // One RefreshIndicator per tab: an outer one would not see the
    // vertical scroll of lists nested in the horizontal TabBarView.
    return RefreshIndicator(
      onRefresh: _refresh,
      child: filteredCodes.isEmpty
          ? PullToRefreshFill(
              child: AppEmptyState(
                icon: source == CodeSource.created
                    ? MingCuteIcons.mgc_qrcode_fill
                    : MingCuteIcons.mgc_scan_fill,
                message:
                    AppLocalizations.of(context)!.favorites_screen_empty_state,
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredCodes.length,
              padding: CodeListTile.listPadding,
              itemBuilder: (context, index) {
                final code = filteredCodes[index];
                return CodeListTile(
                  code: code,
                  onTap: () =>
                      Get.toNamed(AppRoutes.codeDetails, arguments: code),
                );
              },
            ),
    );
  }
}
