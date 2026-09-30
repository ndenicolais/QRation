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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/core/utils/code_type_icon.dart';
import 'package:qration/core/widgets/code_list_tile.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/widgets/app_loader.dart';
import 'package:qration/core/widgets/app_delete_dialog.dart';
import 'package:qration/core/widgets/app_error_state.dart';
import 'package:qration/core/widgets/app_empty_state.dart';
import 'package:qration/core/widgets/app_toast.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

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
    _controller = Get.put(HistoryController());
  }

  @override
  void dispose() {
    Get.delete<HistoryController>();
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
                _buildStandardFilterOptions(),
                _buildSocialFilterOptions(),
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
                icon: Icon(
                  MingCuteIcons.mgc_filter_fill,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  _openFilterDrawer(context);
                },
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

  void _openFilterDrawer(BuildContext context) {
    Widget sourceTile(IconData icon, String label, CodeSource? source) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          label,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14.sp,
          ),
        ),
        onTap: () {
          _controller.setSource(source);
          Get.back();
        },
      );
    }

    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            sourceTile(
              MingCuteIcons.mgc_rows_4_line,
              l10n.history_screen_filter_all,
              null,
            ),
            sourceTile(
              MingCuteIcons.mgc_qrcode_line,
              l10n.history_screen_filter_created,
              CodeSource.created,
            ),
            sourceTile(
              MingCuteIcons.mgc_scan_line,
              l10n.history_screen_filter_scanned,
              CodeSource.scanned,
            ),
          ],
        );
      },
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

  Widget _buildFilterChip({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.r),
      child: FilterChip(
        backgroundColor:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        selectedColor: theme.colorScheme.primary.withValues(alpha: 0.16),
        label: Icon(
          icon,
          size: 18.sp,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.65)
              : theme.colorScheme.outline,
        ),
        elevation: isSelected ? 1.2 : 0,
        showCheckmark: false,
        selected: isSelected,
        onSelected: (_) => onToggle(),
      ),
    );
  }

  Widget _buildStandardFilterOptions() {
    final List<BarcodeType> barcodeTypes =
        AppConstants.customOrderedBarcodeTypes;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
            children: barcodeTypes
                .map((type) => _buildFilterChip(
                      icon: CodeTypeIcon.fromBarcodeType(type, '').icon,
                      isSelected:
                          _controller.selectedStandardTypes.contains(type),
                      onToggle: () => _controller.toggleStandardType(type),
                    ))
                .toList(),
          )),
    );
  }

  Widget _buildSocialFilterOptions() {
    final List<CodeSocial> socialCodes = AppConstants.socialCodesList;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
            children: socialCodes
                .map((social) => _buildFilterChip(
                      icon: social.icon,
                      isSelected:
                          _controller.selectedSocialTypes.contains(social.name),
                      onToggle: () => _controller.toggleSocialType(social.name),
                    ))
                .toList(),
          )),
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
                  ? AppEmptyState(
                      icon: MingCuteIcons.mgc_inbox_2_fill,
                      message: AppLocalizations.of(context)!
                          .history_screen_empty_state,
                    )
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
