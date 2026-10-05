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
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:qration/core/constants/app_version.dart';
import 'package:qration/core/constants/changelog.dart';
import 'package:qration/core/services/changelog_service.dart';
import 'package:qration/core/theme/app_radius.dart';

class AppChangelogDialog extends StatelessWidget {
  final List<ChangelogEntry> entries;

  const AppChangelogDialog({super.key, required this.entries});

  /// Shows the full changelog history, e.g. from a Settings menu entry.
  static Future<void> showAll(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AppChangelogDialog(entries: changelogEntries),
    );
  }

  /// Shows only the entries newer than the last version the user has seen,
  /// once per update (see [ChangelogService.pendingEntries]).
  static Future<void> maybeShow(BuildContext context) async {
    final entriesToShow =
        await ChangelogService.pendingEntries(AppVersion.current);
    if (entriesToShow.isEmpty || !context.mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AppChangelogDialog(entries: entriesToShow),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bulletStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge)),
      backgroundColor: theme.colorScheme.surface,
      title: Text(
        l10n.changelog_dialog_title,
        style: theme.textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in entries) ...[
              Text(
                'v${entry.version}',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              for (final section in entry.sections.entries) ...[
                const SizedBox(height: 12),
                _SectionHeader(type: section.key),
                const SizedBox(height: 6),
                for (final item in section.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('•  ', style: bulletStyle),
                        Expanded(
                          child:
                              Text(item.textBuilder(l10n), style: bulletStyle),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.changelog_dialog_close,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final ChangeType type;

  const _SectionHeader({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.primary;
    final (icon, label) = switch (type) {
      ChangeType.added => (
          MingCuteIcons.mgc_sparkles_line,
          l10n.changelog_section_added,
        ),
      ChangeType.improved => (
          MingCuteIcons.mgc_rocket_line,
          l10n.changelog_section_improved,
        ),
      ChangeType.fixed => (
          MingCuteIcons.mgc_bug_line,
          l10n.changelog_section_fixed,
        ),
      ChangeType.security => (
          MingCuteIcons.mgc_shield_line,
          l10n.changelog_section_security,
        ),
    };
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
