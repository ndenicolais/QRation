// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/codes/screens/code_details_screen.dart';
import 'package:qration/core/utils/code_type_body.dart';
import 'package:qration/core/utils/code_type_icon.dart';
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

class HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final CodesRepository _codesService = Get.find<CodesRepository>();
  late List<CodeModel> historyCodes = [];
  late AnimationController _loadingController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String searchKeyword = '';
  bool _isSelecting = false;
  bool _isLoading = false;
  final Set<String> _selectedIds = {};
  List<BarcodeType> selectedStandardTypes = [];
  final Set<String> selectedSocialTypes = {};
  CodeSource? selectedSource;
  late List<CodeModel> filteredCodes;
  CodeTypeIcon getContentIcon(BarcodeType type, String rawValue) {
    return CodeTypeIcon.fromBarcodeType(type, rawValue);
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
            if (_isLoading)
              Positioned.fill(
                child: _buildDeleteLoading(context),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _searchController.addListener(() {
      setState(() {
        searchKeyword = _searchController.text;
      });
    });
  }

  void _filterDrawerCodes() {
    setState(() {
      if (selectedSource == null) {
        filteredCodes = List.from(historyCodes);
      } else {
        filteredCodes = historyCodes
            .where((code) => code.source == selectedSource)
            .toList();
      }
    });
  }

  void _resetFocus() {
    setState(() {
      searchKeyword = '';
      _searchController.clear();
      _searchFocusNode.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
      child: Row(
        children: [
          if (_isSelecting)
            IconButton(
              tooltip: AppLocalizations.of(context)!
                  .history_screen_tooltip_close_selection,
              icon: Icon(
                MingCuteIcons.mgc_close_fill,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                setState(() {
                  _isSelecting = false;
                  _selectedIds.clear();
                });
              },
            ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              style: AppFonts.montserrat(
                color: theme.colorScheme.onSurface,
                fontSize: 14.sp,
              ),
              cursorColor: theme.colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  searchKeyword = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  MingCuteIcons.mgc_search_2_fill,
                  size: 18.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        tooltip: AppLocalizations.of(context)!
                            .history_screen_tooltip_clear_search,
                        icon: Icon(
                          Icons.clear,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _resetFocus();
                          });
                        },
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
          if (!_isSelecting)
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
          if (!_isSelecting)
            IconButton(
              tooltip: AppLocalizations.of(context)!
                  .history_screen_tooltip_select_mode,
              icon: Icon(
                MingCuteIcons.mgc_delete_3_fill,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                setState(() {
                  _isSelecting = true;
                  _selectedIds.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  void _openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_rows_4_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_all,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = null;
                  _filterDrawerCodes();
                });
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_qrcode_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_created,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = CodeSource.created;
                  _filterDrawerCodes();
                });
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                MingCuteIcons.mgc_scan_line,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.history_screen_filter_scanned,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSource = CodeSource.scanned;
                  _filterDrawerCodes();
                });
                Get.back();
              },
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
        setState(() {
          _isLoading = true;
        });
        final ids = Set<String>.from(_selectedIds);
        await Future.wait(ids.map(_codesService.deleteCode));
        if (!context.mounted) return;
        setState(() {
          _isLoading = false;
          _selectedIds.clear();
          _isSelecting = false;
        });
        showSuccessToast(
          context,
          AppLocalizations.of(context)!
              .history_screen_delete_selected_toast_success,
        );
      },
    );
  }

  Widget _buildStandardFilterOptions() {
    final List<BarcodeType> barcodeTypes =
        AppConstants.customOrderedBarcodeTypes;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: barcodeTypes.map((type) {
              CodeTypeIcon contentIcon = CodeTypeIcon.fromBarcodeType(type, '');
              final isSelected = selectedStandardTypes.contains(type);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.r),
                child: FilterChip(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  selectedColor:
                      theme.colorScheme.primary.withValues(alpha: 0.16),
                  label: Icon(
                    contentIcon.icon,
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
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedStandardTypes.add(type);
                      } else {
                        selectedStandardTypes.remove(type);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialFilterOptions() {
    final List<CodeSocial> socialCodes = AppConstants.socialCodesList;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: socialCodes.map((social) {
              final isSelected = selectedSocialTypes.contains(social.name);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.r),
                child: FilterChip(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  selectedColor:
                      theme.colorScheme.primary.withValues(alpha: 0.16),
                  label: Icon(
                    social.icon,
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
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedSocialTypes.add(social.name);
                      } else {
                        selectedSocialTypes.remove(social.name);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCodesList(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: _codesService.getCodesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_isSelecting) {
          return _buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return AppErrorState(
            title:
                '${AppLocalizations.of(context)!.history_screen_error_state} ${snapshot.error}',
          );
        }

        List<CodeModel> historyCodes = snapshot.data ?? [];
        List<CodeModel> filteredCodes = _filterCodes(historyCodes);

        filteredCodes.sort((a, b) => b.date.compareTo(a.date));

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: filteredCodes.isEmpty && !_isSelecting
                    ? AppEmptyState(
                        icon: MingCuteIcons.mgc_inbox_2_fill,
                        message: AppLocalizations.of(context)!
                            .history_screen_empty_state,
                      )
                    : _buildCodesListView(filteredCodes, context),
              ),
              if (_isSelecting)
                _buildSelectionBottomBar(context, filteredCodes),
            ],
          ),
        );
      },
    );
  }

  List<CodeModel> _filterCodes(List<CodeModel> historyCodes) {
    final Set<BarcodeType> combinedSelectedTypes =
        Set.from(selectedStandardTypes);
    final Set<String> combinedSelectedSocialTypes =
        Set.from(selectedSocialTypes);

    return historyCodes.where((code) {
      bool matchStandardTypeSelected =
          combinedSelectedTypes.contains(code.barcode.type);
      bool matchSocialTypeSelected =
          combinedSelectedSocialTypes.contains(code.socialMedia?.name);

      bool matchesSearchFilter = code.barcode.rawValue != null &&
          code.barcode.rawValue!
              .toLowerCase()
              .contains(searchKeyword.toLowerCase());
      bool matchesSourceFilter =
          selectedSource == null || code.source == selectedSource;

      return (combinedSelectedTypes.isEmpty &&
                  combinedSelectedSocialTypes.isEmpty ||
              matchStandardTypeSelected ||
              matchSocialTypeSelected) &&
          matchesSearchFilter &&
          matchesSourceFilter;
    }).toList();
  }

  Widget _buildCodesListView(
      List<CodeModel> filteredCodes, BuildContext context) {
    return ListView.builder(
      itemCount: filteredCodes.length,
      itemBuilder: (context, index) {
        final code = filteredCodes[index];
        final DateTime date = code.date;
        final String formattedDate =
            DateFormat('dd/MM/yyyy HH:mm').format(date);
        final barcode = code.barcode;
        final barcodeType = barcode.type;
        final rawValue = barcode.rawValue ?? '';
        final contentIcon = getContentIcon(barcodeType, rawValue);
        final contentFormatter = getContentBody(code);
        final displayContent = contentFormatter.formattedContent;

        return _buildCodeCard(
          context,
          code,
          formattedDate,
          contentIcon,
          displayContent,
        );
      },
    );
  }

  Widget _buildCodeCard(
    BuildContext context,
    CodeModel code,
    String formattedDate,
    CodeTypeIcon contentIcon,
    String displayContent,
  ) {
    final isSelected = _selectedIds.contains(code.id);
    return Card(
      color: _isSelecting && isSelected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
          : Theme.of(context).cardTheme.color,
      margin: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: _isSelecting && isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.60)
              : Theme.of(context).colorScheme.outline,
          width: 1.w,
        ),
      ),
      child: ListTile(
        onTap: _isSelecting
            ? () {
                setState(() {
                  if (isSelected) {
                    _selectedIds.remove(code.id);
                  } else {
                    _selectedIds.add(code.id);
                  }
                });
              }
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        leading: _isSelecting
            ? Checkbox(
                value: isSelected,
                onChanged: (_) {
                  setState(() {
                    if (isSelected) {
                      _selectedIds.remove(code.id);
                    } else {
                      _selectedIds.add(code.id);
                    }
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : Icon(
                contentIcon.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
        title: _buildCardTitle(context, code, displayContent),
        subtitle: Text(
          formattedDate,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
          ),
        ),
        trailing: _isSelecting ? null : _buildCardTrailing(context, code),
      ),
    );
  }

  Widget _buildSelectionBottomBar(
      BuildContext context, List<CodeModel> filteredCodes) {
    final theme = Theme.of(context);
    final allSelected =
        filteredCodes.isNotEmpty && _selectedIds.length == filteredCodes.length;
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
          Text(
            '${_selectedIds.length} ${AppLocalizations.of(context)!.history_screen_selected_count}',
            style: AppFonts.montserrat(
              color: theme.colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: filteredCodes.isEmpty
                ? null
                : () {
                    setState(() {
                      if (allSelected) {
                        _selectedIds.clear();
                      } else {
                        _selectedIds.addAll(filteredCodes.map((c) => c.id));
                      }
                    });
                  },
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
              color: _selectedIds.isEmpty
                  ? theme.colorScheme.onSurface.withAlpha(100)
                  : theme.colorScheme.error,
            ),
            onPressed: _selectedIds.isEmpty
                ? null
                : () => _showDeleteSelectedDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle(
    BuildContext context,
    CodeModel code,
    String displayContent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code.source.toString().split('.').last.capitalize!,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
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
    );
  }

  Widget _buildCardTrailing(BuildContext context, CodeModel code) {
    return IconButton(
      tooltip: AppLocalizations.of(context)!.history_screen_tooltip_details,
      icon: Icon(MingCuteIcons.mgc_right_fill,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
      onPressed: () {
        Get.to(
          () => CodeDetailsScreen(code: code),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
