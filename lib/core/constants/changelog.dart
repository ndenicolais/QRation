// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:qration/l10n/app_localizations.dart';

/// Kind of change, used to group the bullets of a version into sections.
/// The enum order is the order of the sections in the dialog.
enum ChangeType { added, improved, fixed, security }

class ChangelogItem {
  final ChangeType type;
  final String Function(AppLocalizations l10n) textBuilder;

  const ChangelogItem(this.type, this.textBuilder);
}

class ChangelogEntry {
  final String version;
  final List<ChangelogItem> items;

  const ChangelogEntry({
    required this.version,
    required this.items,
  });

  /// Items grouped by [ChangeType] in enum order; empty types are omitted.
  Map<ChangeType, List<ChangelogItem>> get sections => {
        for (final type in ChangeType.values)
          if (items.any((item) => item.type == type))
            type: items.where((item) => item.type == type).toList(),
      };
}

/// Newest version first: [ChangelogService.pendingEntries] relies on this
/// order to slice off only the entries newer than the last version seen.
final List<ChangelogEntry> changelogEntries = [
  ChangelogEntry(
    version: '2.0.0',
    items: [
      ChangelogItem(ChangeType.added, (l) => l.changelog_v2_0_0_bullet_2),
      ChangelogItem(ChangeType.added, (l) => l.changelog_v2_0_0_bullet_7),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_1),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_3),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_4),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_5),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_6),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_8),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_9),
      ChangelogItem(ChangeType.improved, (l) => l.changelog_v2_0_0_bullet_10),
      ChangelogItem(ChangeType.security, (l) => l.changelog_v2_0_0_bullet_11),
    ],
  ),
];
