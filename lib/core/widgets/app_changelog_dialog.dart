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
import 'package:qration/core/constants/app_version.dart';
import 'package:qration/core/constants/changelog.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppChangelogDialog extends StatelessWidget {
  static const _lastSeenVersionKey = 'changelog_last_seen_version';

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
  /// once per version bump. Does nothing on first install (there is nothing
  /// "new" to a user who has never used a previous version) and does nothing
  /// if the app hasn't been updated since the dialog was last shown.
  static Future<void> maybeShow(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeenVersion = prefs.getString(_lastSeenVersionKey);

    if (lastSeenVersion == AppVersion.current) return;
    if (lastSeenVersion == null) {
      await prefs.setString(_lastSeenVersionKey, AppVersion.current);
      return;
    }

    final lastSeenIndex = changelogEntries.indexWhere(
      (entry) => entry.version == lastSeenVersion,
    );
    final entriesToShow = lastSeenIndex == -1
        ? changelogEntries
        : changelogEntries.sublist(0, lastSeenIndex);

    await prefs.setString(_lastSeenVersionKey, AppVersion.current);
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
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              for (final bullet in entry.bulletsBuilder(l10n))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•  ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
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
