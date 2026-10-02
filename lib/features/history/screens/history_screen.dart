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
import 'package:qration/core/theme/app_radius.dart';
import 'package:flutter/services.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/features/history/widgets/history_filter_sheet.dart';
import 'package:qration/core/widgets/code_list_tile.dart';
import 'package:qration/core/widgets/app_loader.dart';
import 'package:qration/core/widgets/app_delete_dialog.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_empty_state.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/core/widgets/sync_status_banner.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.onScanNow});

  /// Empty-state call to action (e.g. switch Home to the Scanner tab).
  final VoidCallback? onScanNow;

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _controller;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HistoryController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(context),
                SizedBox(height: 10),
                _buildCodesList(context),
              ],
            ),
            Obx(() => _controller.isDeleting.value
                ? Positioned.fill(child: _buildDeleteLoading(context))
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _resetFocus() {
    _searchController.clear();
    _controller.clearSearch();
    _searchFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _clearFilters() {
    _resetFocus();
    _controller.clearFilters();
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_controller.hasCodes && _controller.hasActiveFilters) {
      return AppEmptyState(
        icon: MingCuteIcons.mgc_filter_fill,
        message: l10n.history_screen_empty_filtered,
        actionLabel: l10n.history_screen_clear_filters,
        onAction: _clearFilters,
      );
    }
    return AppEmptyState(
      icon: MingCuteIcons.mgc_inbox_2_fill,
      message: l10n.history_screen_empty_state,
      actionLabel: l10n.history_screen_empty_action,
      onAction: widget.onScanNow,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: AppLoader(),
    );
  }

  Widget _buildDeleteLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
      child: Center(child: _buildLoadingIndicator()),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Obx(() {
        final isSelecting = _controller.isSelecting.value;
        // The search row turns into a contextual selection bar.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.25),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: isSelecting
              ? _buildSelectionBar(context)
              : _buildSearchRow(context),
        );
      }),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasSearch = _controller.searchInput.value.isNotEmpty;
    final activeFilters = _controller.activeFilterCount;
    return Row(
      key: const ValueKey('search'),
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: Theme.of(context).textTheme.bodyMedium,
            cursorColor: theme.colorScheme.primary,
            onChanged: _controller.onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MingCuteIcons.mgc_search_2_fill,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: hasSearch
                  ? IconButton(
                      tooltip: l10n.history_screen_tooltip_clear_search,
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _resetFocus,
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.35),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              labelText: l10n.history_screen_search_label,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.large),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.large),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.large),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.history_screen_tooltip_filter,
          icon: Badge(
            isLabelVisible: activeFilters > 0,
            label: Text('$activeFilters'),
            child: Icon(
              MingCuteIcons.mgc_filter_fill,
              color: activeFilters > 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
          onPressed: () => showHistoryFilterSheet(context, _controller),
        ),
        IconButton(
          tooltip: l10n.history_screen_tooltip_select_mode,
          icon: Icon(
            MingCuteIcons.mgc_delete_3_fill,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            _controller.startSelection();
          },
        ),
      ],
    );
  }

  /// Contextual bar shown while selecting: close, count, select all, delete.
  Widget _buildSelectionBar(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedCount = _controller.selectedIds.length;
    final allSelected = _controller.allSelected;
    return Container(
      key: const ValueKey('selection'),
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.history_screen_tooltip_close_selection,
            icon: Icon(
              MingCuteIcons.mgc_close_line,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: _controller.cancelSelection,
          ),
          Expanded(
            child: Text(
              '$selectedCount ${l10n.history_screen_selected_count}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            tooltip: allSelected
                ? l10n.history_screen_deselect_all
                : l10n.history_screen_select_all,
            icon: Icon(
              allSelected
                  ? MingCuteIcons.mgc_check_circle_fill
                  : MingCuteIcons.mgc_check_circle_line,
              color: theme.colorScheme.primary,
            ),
            onPressed: _controller.filteredCodes.isEmpty
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    _controller.toggleSelectAll();
                  },
          ),
          IconButton(
            tooltip: l10n.history_screen_tooltip_delete,
            icon: Icon(
              MingCuteIcons.mgc_delete_3_fill,
              color: selectedCount == 0
                  ? theme.colorScheme.onSurface.withAlpha(100)
                  : theme.colorScheme.error,
            ),
            onPressed: selectedCount == 0
                ? null
                : () => _showDeleteSelectedDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteSelectedDialog(BuildContext context) {
    AppDeleteDialog.show(
      context: context,
      title: AppLocalizations.of(context)!.history_screen_delete_title,
      message: AppLocalizations.of(context)!
          .history_screen_delete_selected_description,
      onConfirm: () async {
        final deleted = await _controller.deleteSelected();
        if (!context.mounted) return;
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.history_screen_deleted_count(deleted),
        );
      },
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

  Widget _buildCodesList(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (_controller.isLoading.value) {
          return _buildLoadingIndicator();
        }

        final error = _controller.error.value;
        if (error != null) {
          return AppErrorState(
            title:
                '${AppLocalizations.of(context)!.history_screen_error_state} $error',
          );
        }

        final filteredCodes = _controller.filteredCodes;
        final isSelecting = _controller.isSelecting.value;

        return Column(
          children: [
            Obx(() => SyncStatusBanner(status: _controller.syncStatus.value)),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: filteredCodes.isEmpty && !isSelecting
                    ? PullToRefreshFill(child: _buildEmptyState(context))
                    : _buildCodesListView(filteredCodes, isSelecting),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCodesListView(List<CodeModel> filteredCodes, bool isSelecting) {
    return ListView.builder(
      // Short lists must still overscroll for pull-to-refresh.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filteredCodes.length,
      padding: CodeListTile.listPadding,
      itemBuilder: (context, index) {
        final code = filteredCodes[index];
        // Own Obx so toggling a checkbox rebuilds only this card.
        return Obx(() => CodeListTile(
              code: code,
              showSource: true,
              selectable: isSelecting,
              selected: _controller.selectedIds.contains(code.id),
              onSelectedChanged: (_) {
                HapticFeedback.selectionClick();
                _controller.toggleSelected(code.id);
              },
              onLongPress: isSelecting
                  ? null
                  : () {
                      HapticFeedback.mediumImpact();
                      _controller.startSelectionWith(code.id);
                    },
              onTap: () => Get.toNamed(AppRoutes.codeDetails, arguments: code),
            ));
      },
    );
  }
}
