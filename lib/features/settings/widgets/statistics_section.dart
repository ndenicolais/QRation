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
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/widgets/section_card.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({
    super.key,
    required this.totalCodes,
    required this.createdCodesCount,
    required this.scannedCodesCount,
    required this.standardCodesByCreated,
    required this.socialCodesByCreated,
    required this.standardCodesByScanned,
    required this.socialCodesByScanned,
  });

  final int? totalCodes;
  final int? createdCodesCount;
  final int? scannedCodesCount;
  final Map<String, int>? standardCodesByCreated;
  final Map<String, int>? socialCodesByCreated;
  final Map<String, int>? standardCodesByScanned;
  final Map<String, int>? socialCodesByScanned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final total = totalCodes ?? 0;
    final created = createdCodesCount ?? 0;
    final scanned = scannedCodesCount ?? 0;
    final createdRatio = total > 0 ? created / total : 0.0;

    return SectionCard(
      title: l10n.database_screen_codes_field_total_title,
      icon: MingCuteIcons.mgc_chart_bar_fill,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: MingCuteIcons.mgc_layers_fill,
                  value: total,
                  label: l10n.database_screen_codes_field_total_saved,
                  color: theme.colorScheme.onSurface,
                  background: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: MingCuteIcons.mgc_qrcode_fill,
                  value: created,
                  label: l10n.database_screen_codes_field_created_title,
                  color: theme.colorScheme.primary,
                  background: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: MingCuteIcons.mgc_scan_fill,
                  value: scanned,
                  label: l10n.database_screen_codes_field_scanned_title,
                  color: AppColors.qrGold,
                  background: AppColors.qrGold.withValues(alpha: 0.10),
                ),
              ),
            ],
          ),
          SizedBox(height: 22),
          _DistributionBar(
            created: created,
            scanned: scanned,
            total: total,
            createdRatio: createdRatio,
          ),
          SizedBox(height: 22),
          _SourceTile(
            label: l10n.database_screen_codes_field_created_title,
            icon: MingCuteIcons.mgc_qrcode_fill,
            color: theme.colorScheme.primary,
            standardCounts: standardCodesByCreated,
            socialCounts: socialCodesByCreated,
          ),
          SizedBox(height: 10),
          _SourceTile(
            label: l10n.database_screen_codes_field_scanned_title,
            icon: MingCuteIcons.mgc_scan_fill,
            color: AppColors.qrGold,
            standardCounts: standardCodesByScanned,
            socialCounts: socialCodesByScanned,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(height: 6),
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({
    required this.created,
    required this.scanned,
    required this.total,
    required this.createdRatio,
  });

  final int created;
  final int scanned;
  final int total;
  final double createdRatio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scannedRatio = total > 0 ? scanned / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LegendDot(theme.colorScheme.primary),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                l10n.database_screen_codes_field_created_title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(width: 4),
            Text(
              total > 0 ? '${(createdRatio * 100).toStringAsFixed(0)}%' : '0%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            Text(
              total > 0 ? '${(scannedRatio * 100).toStringAsFixed(0)}%' : '0%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.qrGold,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                l10n.database_screen_codes_field_scanned_title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(width: 4),
            _LegendDot(AppColors.qrGold),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.small),
          child: SizedBox(
            height: 10,
            child: total > 0
                ? Row(
                    children: [
                      Flexible(
                        flex: created,
                        child: Container(color: theme.colorScheme.primary),
                      ),
                      if (scanned > 0)
                        Flexible(
                          flex: scanned,
                          child: Container(color: AppColors.qrGold),
                        ),
                    ],
                  )
                : Container(
                    color: theme.colorScheme.outlineVariant,
                  ),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.standardCounts,
    required this.socialCounts,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Map<String, int>? standardCounts;
  final Map<String, int>? socialCounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasStandard = standardCounts != null && standardCounts!.isNotEmpty;
    final hasSocial = socialCounts != null && socialCounts!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
          if (hasStandard || hasSocial) ...[
            Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant),
            _BreakdownTile(
              label: l10n.database_screen_codes_field_standard_title,
              icon: MingCuteIcons.mgc_grid_fill,
              counts: standardCounts,
              dialogTitle: l10n.database_screen_codes_dialog_standard,
              isEmpty: !hasStandard,
            ),
            Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant),
            _BreakdownTile(
              label: l10n.database_screen_codes_field_social_title,
              icon: MingCuteIcons.mgc_share_3_fill,
              counts: socialCounts,
              dialogTitle: l10n.database_screen_codes_dialog_social,
              isEmpty: !hasSocial,
            ),
          ] else ...[
            Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    MingCuteIcons.mgc_inbox_2_fill,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 8),
                  Text(
                    l10n.database_screen_codes_field_empty,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.label,
    required this.icon,
    required this.counts,
    required this.dialogTitle,
    required this.isEmpty,
  });

  final String label;
  final IconData icon;
  final Map<String, int>? counts;
  final String dialogTitle;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppRadius.large),
        bottomRight: Radius.circular(AppRadius.large),
      ),
      onTap: isEmpty || counts == null
          ? null
          : () => showCodesBreakdownDialog(context, dialogTitle, counts!),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            if (!isEmpty) _TypeBadges(counts: counts!),
            if (!isEmpty) SizedBox(width: 6),
            Icon(
              isEmpty
                  ? MingCuteIcons.mgc_inbox_2_fill
                  : MingCuteIcons.mgc_right_fill,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadges extends StatelessWidget {
  const _TypeBadges({required this.counts});

  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = counts.entries.toList();
    final display = entries.take(3).toList();
    final remaining = entries.length - display.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...display.map(
          (e) => Container(
            margin: EdgeInsets.only(right: 4),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.extraSmall),
            ),
            child: Text(
              '${e.key}: ${e.value}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
            ),
          ),
        ),
        if (remaining > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.extraSmall),
            ),
            child: Text(
              '+$remaining',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
      ],
    );
  }
}

void showCodesBreakdownDialog(
  BuildContext context,
  String title,
  Map<String, int> counts,
) {
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: theme.cardTheme.color ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          side: BorderSide(color: theme.colorScheme.outline),
        ),
        title: Row(
          children: [
            Icon(MingCuteIcons.mgc_chart_pie_fill,
                color: theme.colorScheme.primary, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: counts.entries.map((entry) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                    ),
                    child: Text(
                      '${entry.value}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            child: Text(
              l10n.database_screen_codes_dialog_close,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
            ),
          ),
        ],
      );
    },
  );
}
