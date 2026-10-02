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
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/utils/code_type_icon.dart';
import 'package:qration/core/utils/code_type_text.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Opens the History filter sheet. Filters apply live as they are toggled.
Future<void> showHistoryFilterSheet(
  BuildContext context,
  HistoryController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => HistoryFilterSheet(controller: controller),
  );
}

/// Source, code type and social filters of the History tab in one place.
class HistoryFilterSheet extends StatelessWidget {
  const HistoryFilterSheet({super.key, required this.controller});

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: Obx(() {
        final activeCount = controller.activeFilterCount;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.history_filter_sheet_title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionTitle(l10n.history_filter_sheet_source),
                    SegmentedButton<CodeSource?>(
                      segments: [
                        ButtonSegment(
                          value: null,
                          icon: const Icon(MingCuteIcons.mgc_rows_4_line),
                          label: Text(l10n.history_screen_filter_all),
                        ),
                        ButtonSegment(
                          value: CodeSource.created,
                          icon: const Icon(MingCuteIcons.mgc_qrcode_line),
                          label: Text(l10n.history_screen_filter_created),
                        ),
                        ButtonSegment(
                          value: CodeSource.scanned,
                          icon: const Icon(MingCuteIcons.mgc_scan_line),
                          label: Text(l10n.history_screen_filter_scanned),
                        ),
                      ],
                      selected: {controller.selectedSource.value},
                      showSelectedIcon: false,
                      onSelectionChanged: (selection) =>
                          controller.setSource(selection.first),
                    ),
                    _SectionTitle(l10n.history_filter_sheet_types),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final type
                            in AppConstants.customOrderedBarcodeTypes)
                          FilterChip(
                            avatar: Icon(
                              CodeTypeIcon.fromBarcodeType(type, '').icon,
                              size: 18,
                            ),
                            label: Text(
                              CodeTypeText.fromBarcodeType(type, '', l10n).type,
                            ),
                            selected:
                                controller.selectedStandardTypes.contains(type),
                            showCheckmark: false,
                            onSelected: (_) =>
                                controller.toggleStandardType(type),
                          ),
                      ],
                    ),
                    _SectionTitle(l10n.history_filter_sheet_social),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final social in AppConstants.socialCodesList)
                          FilterChip(
                            avatar: Icon(social.icon, size: 18),
                            label: Text(social.name),
                            selected: controller.selectedSocialTypes
                                .contains(social.name),
                            showCheckmark: false,
                            onSelected: (_) =>
                                controller.toggleSocialType(social.name),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: activeCount == 0
                          ? null
                          : controller.clearSheetFilters,
                      child: Text(l10n.history_screen_clear_filters),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.history_filter_sheet_show_results),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
