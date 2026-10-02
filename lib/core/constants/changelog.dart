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
      l10n.changelog_v1_1_0_bullet_1,
      l10n.changelog_v1_1_0_bullet_2,
      l10n.changelog_v2_0_0_bullet_3,
      l10n.changelog_v2_0_0_bullet_4,
      l10n.changelog_v2_0_0_bullet_5,
      l10n.changelog_v2_0_0_bullet_6,
      l10n.changelog_v2_0_0_bullet_7,
      l10n.changelog_v2_0_0_bullet_8,
      l10n.changelog_v2_0_0_bullet_9,
      l10n.changelog_v2_0_0_bullet_10,
      l10n.changelog_v2_0_0_bullet_11,
      l10n.changelog_v2_0_0_bullet_12,
      l10n.changelog_v2_0_0_bullet_13,
      l10n.changelog_v2_0_0_bullet_14,
      l10n.changelog_v2_0_0_bullet_15,
      l10n.changelog_v2_0_0_bullet_16,
      l10n.changelog_v2_0_0_bullet_17,
      l10n.changelog_v2_0_0_bullet_18,
      l10n.changelog_v2_0_0_bullet_19,
      l10n.changelog_v2_0_0_bullet_20,
      l10n.changelog_v2_0_0_bullet_21,
      l10n.changelog_v2_0_0_bullet_22,
      l10n.changelog_v2_0_0_bullet_23,
      l10n.changelog_v2_0_0_bullet_24,
      l10n.changelog_v2_0_0_bullet_25,
      l10n.changelog_v2_0_0_bullet_26,
      l10n.changelog_v2_0_0_bullet_27,
      l10n.changelog_v2_0_0_bullet_28,
      l10n.changelog_v2_0_0_bullet_29,
      l10n.changelog_v2_0_0_bullet_30,
      l10n.changelog_v2_0_0_bullet_31,
      l10n.changelog_v2_0_0_bullet_32,
      l10n.changelog_v2_0_0_bullet_33,
      l10n.changelog_v2_0_0_bullet_34,
      l10n.changelog_v2_0_0_bullet_35,
      l10n.changelog_v2_0_0_bullet_36,
      l10n.changelog_v2_0_0_bullet_37,
      l10n.changelog_v2_0_0_bullet_38,
      l10n.changelog_v2_0_0_bullet_39,
      l10n.changelog_v2_0_0_bullet_40,
      l10n.changelog_v2_0_0_bullet_41,
      l10n.changelog_v2_0_0_bullet_42,
      l10n.changelog_v2_0_0_bullet_43,
      l10n.changelog_v2_0_0_bullet_44,
      l10n.changelog_v2_0_0_bullet_45,
      l10n.changelog_v2_0_0_bullet_46,
      l10n.changelog_v2_0_0_bullet_47,
      l10n.changelog_v2_0_0_bullet_48,
      l10n.changelog_v2_0_0_bullet_49,
      l10n.changelog_v2_0_0_bullet_50,
      l10n.changelog_v2_0_0_bullet_51,
    ],
  ),
];
