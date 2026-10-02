// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:qration/l10n/app_localizations.dart';

class ChangelogEntry {
  final String version;
  final List<String> Function(AppLocalizations l10n) bulletsBuilder;

  const ChangelogEntry({required this.version, required this.bulletsBuilder});
}

/// Ordered newest-first: [AppChangelogDialog.maybeShow] relies on this order
/// to slice off only the entries newer than the last version the user saw.
final List<ChangelogEntry> changelogEntries = [
  ChangelogEntry(
    version: '2.0.0',
    bulletsBuilder: (l10n) => [
      l10n.changelog_v2_0_0_bullet_1,
      l10n.changelog_v2_0_0_bullet_2,
      l10n.changelog_v2_0_0_bullet_3,
      l10n.changelog_v2_0_0_bullet_4,
      l10n.changelog_v2_0_0_bullet_5,
      l10n.changelog_v2_0_0_bullet_6,
      l10n.changelog_v2_0_0_bullet_7,
      l10n.changelog_v2_0_0_bullet_8,
      l10n.changelog_v2_0_0_bullet_9,
      l10n.changelog_v2_0_0_bullet_10,
    ],
  ),
];
