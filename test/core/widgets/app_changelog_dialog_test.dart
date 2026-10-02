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
    testWidgets('shows every entry with its category in bold ($locale)',
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
      expect(find.text(l10n.changelog_dialog_title), findsOneWidget);
      for (final entry in changelogEntries) {
        for (final bullet in entry.bulletsBuilder(l10n)) {
          final rich = find.byWidgetPredicate(
            (w) => w is RichText && w.text.toPlainText() == bullet,
          );
          await tester.scrollUntilVisible(rich, 200,
              scrollable: find.byType(Scrollable).first);
          // "Category:" is the first span with its own text, in bold.
          TextSpan? category;
          tester.widget<RichText>(rich).text.visitChildren((span) {
            if (span is TextSpan && span.text != null) {
              category = span;
              return false;
            }
            return true;
          });
          expect(category?.text, endsWith(':'));
          expect(category?.style?.fontWeight, FontWeight.w600);
        }
      }
    });
  }
}
