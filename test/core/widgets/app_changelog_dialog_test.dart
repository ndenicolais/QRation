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
import 'package:flutter_test/flutter_test.dart';
import 'package:qration/core/constants/changelog.dart';
import 'package:qration/core/widgets/app_changelog_dialog.dart';
import 'package:qration/l10n/app_localizations.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('shows every entry grouped into sections ($locale)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AppChangelogDialog(entries: changelogEntries),
          ),
        ),
      );
      await tester.pump();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(AppChangelogDialog)))!;
      final scrollable = find.byType(Scrollable).first;
      for (final entry in changelogEntries) {
        await tester.scrollUntilVisible(find.text('v${entry.version}'), 200,
            scrollable: scrollable);
        for (final item in entry.items) {
          await tester.scrollUntilVisible(
              find.text(item.textBuilder(l10n)), 200,
              scrollable: scrollable);
        }
      }
      expect(find.text(l10n.changelog_section_security), findsWidgets);
    });
  }
}
