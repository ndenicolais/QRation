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
                SizedBox(height: 10.h),
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
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.r),
      child: Obx(() {
        final isSelecting = _controller.isSelecting.value;
        final hasSearch = _controller.searchInput.value.isNotEmpty;
        return Row(
          children: [
            if (isSelecting)
              IconButton(
                tooltip: AppLocalizations.of(context)!
                    .history_screen_tooltip_close_selection,
                icon: Icon(
                  MingCuteIcons.mgc_close_fill,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: _controller.cancelSelection,
              ),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                style: AppFonts.montserrat(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
                cursorColor: theme.colorScheme.primary,
                onChanged: _controller.onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    MingCuteIcons.mgc_search_2_fill,
                    size: 18.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: hasSearch
                      ? IconButton(
                          tooltip: AppLocalizations.of(context)!
                              .history_screen_tooltip_clear_search,
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
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  labelText:
                      AppLocalizations.of(context)!.history_screen_search_label,
                  labelStyle: AppFonts.montserrat(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            if (!isSelecting)
              IconButton(
                tooltip:
                    AppLocalizations.of(context)!.history_screen_tooltip_filter,
                icon: Badge(
                  isLabelVisible: _controller.activeFilterCount > 0,
                  label: Text('${_controller.activeFilterCount}'),
                  child: Icon(
                    MingCuteIcons.mgc_filter_fill,
                    color: _controller.activeFilterCount > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                onPressed: () => showHistoryFilterSheet(context, _controller),
              ),
            if (!isSelecting)
              IconButton(
                tooltip: AppLocalizations.of(context)!
                    .history_screen_tooltip_select_mode,
                icon: Icon(
                  MingCuteIcons.mgc_delete_3_fill,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: _controller.startSelection,
              ),
          ],
        );
      }),
    );
  }

  void _showDeleteSelectedDialog(BuildContext context) {
    AppDeleteDialog.show(
      context: context,
      title: AppLocalizations.of(context)!.history_screen_delete_title,
      message: AppLocalizations.of(context)!
          .history_screen_delete_selected_description,
      onConfirm: () async {
        await _controller.deleteSelected();
        if (!context.mounted) return;
        showSuccessToast(
          context,
          AppLocalizations.of(context)!
              .history_screen_delete_selected_toast_success,
        );
      },
    );
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
            Expanded(
              child: filteredCodes.isEmpty && !isSelecting
                  ? _buildEmptyState(context)
                  : _buildCodesListView(filteredCodes, isSelecting),
            ),
            if (isSelecting)
              Obx(() =>
                  _buildSelectionBottomBar(context, _controller.filteredCodes)),
          ],
        );
      }),
    );
  }

  Widget _buildCodesListView(List<CodeModel> filteredCodes, bool isSelecting) {
    return ListView.builder(
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
              onSelectedChanged: (_) => _controller.toggleSelected(code.id),
              onTap: () => Get.toNamed(AppRoutes.codeDetails, arguments: code),
            ));
      },
    );
  }

  Widget _buildSelectionBottomBar(
      BuildContext context, List<CodeModel> filteredCodes) {
    final theme = Theme.of(context);
    final selectedCount = _controller.selectedIds.length;
    final allSelected = _controller.allSelected;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedCount ${AppLocalizations.of(context)!.history_screen_selected_count}',
              style: AppFonts.montserrat(
                color: theme.colorScheme.onSurface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed:
                filteredCodes.isEmpty ? null : _controller.toggleSelectAll,
            child: Text(
              allSelected
                  ? AppLocalizations.of(context)!.history_screen_deselect_all
                  : AppLocalizations.of(context)!.history_screen_select_all,
              style: AppFonts.montserrat(
                color: theme.colorScheme.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            tooltip:
                AppLocalizations.of(context)!.history_screen_tooltip_delete,
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
}
