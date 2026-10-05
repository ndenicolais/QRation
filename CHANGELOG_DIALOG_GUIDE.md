# "What's new" dialog — reusable Flutter guide

A localized changelog dialog grouped by type of change (**New**, **Improvements**, **Fixes**, **Security**). It is shown automatically **once after each update** and can also be opened manually (e.g. from Settings).

Extracted from Shox. Every snippet below is self-contained: replace `your_app` with the package name of the target app.

---

## 1. Behavior

| Situation | Result |
|---|---|
| Fresh install | Nothing is shown; the current version is recorded |
| App updated (last seen version is in the list) | Only the entries newer than the last seen version are shown |
| App updated from a version missing in the list | All entries are shown |
| Same version opened again | Nothing is shown |
| Manual opening (Settings / Dashboard) | All entries are shown |

Inside each version, bullets are grouped into sections in a fixed order (New → Improvements → Fixes → Security). Each section has an icon and a localized title, and empty sections are hidden.

## 2. Requirements

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
  shared_preferences: ^2.3.4    # last seen version
  package_info_plus: ^9.0.0     # current version, read from pubspec.yaml

flutter:
  generate: true                # gen-l10n (l10n.yaml + lib/l10n/*.arb)
```

The `version:` in `pubspec.yaml` is the single source of truth. Each `ChangelogEntry.version` must match it exactly, without the build number (`5.0.0`, not `5.0.0+2`).

## 3. File layout

```
lib/
├── core/
│   ├── constants/changelog.dart            # model + entries
│   └── services/changelog_service.dart     # which entries to show
├── common/widgets/changelog_dialog_widget.dart
└── l10n/app_*.arb                          # section titles + bullets
test/
├── core/constants/changelog_test.dart
└── core/services/changelog_service_test.dart
```

## 4. Model and entries — `lib/core/constants/changelog.dart`

```dart
import 'package:your_app/l10n/app_localizations.dart';

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

/// Newest version first.
final List<ChangelogEntry> changelogEntries = [
  ChangelogEntry(
    version: '1.1.0',
    items: [
      ChangelogItem(ChangeType.added, (l) => l.changelog_v1_1_0_bullet_1),
      ChangelogItem(ChangeType.fixed, (l) => l.changelog_v1_1_0_bullet_2),
    ],
  ),
  ChangelogEntry(
    version: '1.0.0',
    items: [
      ChangelogItem(ChangeType.added, (l) => l.changelog_v1_0_0_bullet_1),
    ],
  ),
];
```

The texts are functions of `AppLocalizations` and not plain strings, so the list is a top-level constant that does not need a `BuildContext`, and the dialog always shows the current language.

## 5. Service — `lib/core/services/changelog_service.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app/core/constants/changelog.dart';

/// Decides which "what's new" entries to show after an update.
class ChangelogService {
  static const String prefsLastSeenVersion = 'last_seen_changelog_version';

  /// Returns the entries newer than the version the user last saw and
  /// records [currentVersion] as seen.
  ///
  /// On a fresh install nothing is shown: the current version is only
  /// recorded, so the dialog appears from the next update on.
  static Future<List<ChangelogEntry>> pendingEntries(
    String currentVersion, {
    List<ChangelogEntry>? entries,
  }) async {
    final all = entries ?? changelogEntries;
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString(prefsLastSeenVersion);

    if (lastSeen == currentVersion) return const [];
    await prefs.setString(prefsLastSeenVersion, currentVersion);
    if (lastSeen == null) return const [];

    final lastSeenIndex = all.indexWhere((e) => e.version == lastSeen);
    return lastSeenIndex == -1 ? all : all.sublist(0, lastSeenIndex);
  }
}
```

## 6. Dialog — `lib/common/widgets/changelog_dialog_widget.dart`

Material icons by default. If the app uses another icon set, change only the `switch`. For example, with `ming_cute_icons`: `mgc_sparkles_line`, `mgc_rocket_line`, `mgc_bug_line`, `mgc_shield_line`.

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/constants/changelog.dart';
import 'package:your_app/l10n/app_localizations.dart';

class ChangelogDialogWidget extends StatelessWidget {
  final List<ChangelogEntry> entries;

  const ChangelogDialogWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.changelog_dialog_title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in entries) ...[
              Text(
                'v${entry.version}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
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
                        const Text('•  '),
                        Expanded(child: Text(item.textBuilder(l10n))),
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.changelog_dialog_close),
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
          Icons.auto_awesome_outlined,
          l10n.changelog_section_added,
        ),
      ChangeType.improved => (
          Icons.rocket_launch_outlined,
          l10n.changelog_section_improved,
        ),
      ChangeType.fixed => (
          Icons.bug_report_outlined,
          l10n.changelog_section_fixed,
        ),
      ChangeType.security => (
          Icons.shield_outlined,
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
```

`Expanded` around the title and the bullets keeps long texts and large system font sizes from overflowing.

## 7. Localization keys

Add these keys to **every** ARB file, then run `flutter gen-l10n`.

| Key | en | it | de | es | fr |
|---|---|---|---|---|---|
| `changelog_dialog_title` | What's new | Novità | Neuigkeiten | Novedades | Nouveautés |
| `changelog_dialog_close` | Close | Chiudi | Schließen | Cerrar | Fermer |
| `changelog_section_added` | New | Novità | Neu | Novedades | Nouveautés |
| `changelog_section_improved` | Improvements | Miglioramenti | Verbesserungen | Mejoras | Améliorations |
| `changelog_section_fixed` | Fixes | Correzioni | Fehlerbehebungen | Correcciones | Corrections |
| `changelog_section_security` | Security | Sicurezza | Sicherheit | Seguridad | Sécurité |

Bullets use the format `changelog_v<major>_<minor>_<patch>_bullet_<N>`, for example:

```json
"changelog_v1_1_0_bullet_1": "Search now also matches notes and categories.",
"changelog_v1_1_0_bullet_2": "Fixed the chart overlapping the legend in dark theme."
```

## 8. Wiring

**Automatically after an update**, on the first screen after login (or the home screen of an app without login):

```dart
import 'package:package_info_plus/package_info_plus.dart';

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowChangelog());
}

Future<void> _maybeShowChangelog() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final entriesToShow =
      await ChangelogService.pendingEntries(packageInfo.version);
  if (entriesToShow.isEmpty || !mounted) return;

  await showDialog<void>(
    context: context,
    builder: (context) => ChangelogDialogWidget(entries: entriesToShow),
  );
}
```

**Manually**, from a Settings or Dashboard item:

```dart
onTap: () => showDialog<void>(
  context: context,
  builder: (context) => ChangelogDialogWidget(entries: changelogEntries),
),
```

## 9. Tests

`test/core/services/changelog_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app/core/constants/changelog.dart';
import 'package:your_app/core/services/changelog_service.dart';

ChangelogEntry entry(String version) =>
    ChangelogEntry(version: version, items: const []);

void main() {
  // Newest first, as in changelog.dart.
  final entries = [entry('3.0.0'), entry('2.0.0'), entry('1.0.0')];

  Future<String?> lastSeen() async => (await SharedPreferences.getInstance())
      .getString(ChangelogService.prefsLastSeenVersion);

  void givenLastSeen(String? version) => SharedPreferences.setMockInitialValues(
        {if (version != null) ChangelogService.prefsLastSeenVersion: version},
      );

  test('fresh install shows nothing but records the version', () async {
    givenLastSeen(null);
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        isEmpty);
    expect(await lastSeen(), '3.0.0');
  });

  test('shows only the entries newer than the last seen version', () async {
    givenLastSeen('1.0.0');
    final result =
        await ChangelogService.pendingEntries('3.0.0', entries: entries);
    expect(result.map((e) => e.version), ['3.0.0', '2.0.0']);
  });

  test('shows everything when the last seen version is unknown', () async {
    givenLastSeen('0.9.0');
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        hasLength(3));
  });

  test('shows nothing when the version was already seen', () async {
    givenLastSeen('3.0.0');
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        isEmpty);
  });
}
```

`test/core/constants/changelog_test.dart` checks the grouping and fails if a bullet in the ARB files is never listed, or is listed twice:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/constants/changelog.dart';

void main() {
  test('sections follow the ChangeType order and skip empty types', () {
    String text(_) => '';
    final entry = ChangelogEntry(
      version: '1.0.0',
      items: [
        ChangelogItem(ChangeType.fixed, text),
        ChangelogItem(ChangeType.added, text),
        ChangelogItem(ChangeType.fixed, text),
      ],
    );

    expect(entry.sections.keys, [ChangeType.added, ChangeType.fixed]);
    expect(entry.sections[ChangeType.fixed], hasLength(2));
  });

  test('every changelog bullet in the ARB files is listed once', () {
    // Use the template ARB file declared in l10n.yaml.
    final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;
    final source = File('lib/core/constants/changelog.dart').readAsStringSync();

    final keys = arb.keys.where((k) => k.startsWith('changelog_v'));
    for (final key in keys) {
      expect(
        'l.$key)'.allMatches(source),
        hasLength(1),
        reason: '$key must appear exactly once in changelogEntries',
      );
    }
    expect(
      changelogEntries.fold<int>(0, (sum, e) => sum + e.items.length),
      keys.length,
    );
  });
}
```

## 10. Adding a release

1. Bump `version:` in `pubspec.yaml`.
2. Add a `ChangelogEntry` with the same version **at the top** of `changelogEntries`.
3. For each user-facing change, add a `ChangelogItem` with its type:
   - `added` — a new feature or screen;
   - `improved` — an existing feature that works better, faster or looks better;
   - `fixed` — a bug that has been solved;
   - `security` — data protection, permissions, privacy.

   Internal refactors do not go in the changelog.
4. Add the `changelog_v<version>_bullet_N` keys to every ARB file and run `flutter gen-l10n`.
5. Run `flutter test`. The changelog test fails if a bullet is missing or duplicated.

Write bullets for users: one sentence on what changes for them, without technical terms.

## 11. Snippet for the CLAUDE.md of each app

```markdown
- If a change is user-facing (new feature, visible improvement, bug fix, security), add a
  `ChangelogItem` with its `ChangeType` (`added` / `improved` / `fixed` / `security`) to the
  entry of the current version in `lib/core/constants/changelog.dart`, plus the matching
  `changelog_v<version>_bullet_N` keys in all ARB files under `lib/l10n/`, then run
  `flutter gen-l10n`. Bump `version:` in `pubspec.yaml` if the current version is already
  released. Internal refactors do not go in the changelog.
```
