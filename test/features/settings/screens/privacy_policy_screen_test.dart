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
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/features/settings/screens/privacy_policy_screen.dart';
import 'package:qration/l10n/app_localizations.dart';

/// The screen is a full Scaffold with its own ListView, so it can't go
/// through `pumpLocalizedWidget` (which wraps the child in a scroll view).
Future<void> _pumpScreen(WidgetTester tester, Locale locale) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PrivacyPolicyScreen(),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows date, controller and every section in English',
      (tester) async {
    await _pumpScreen(tester, const Locale('en'));

    expect(find.text('Last updated: October 2, 2026'), findsOneWidget);
    expect(
      find.textContaining(AppConstants.developerEmail),
      findsOneWidget,
    );

    for (final title in [
      '1. Data controller',
      '5. On-device processing',
      '10. Changes',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 200);
      expect(find.text(title), findsOneWidget);
    }

    await tester.scrollUntilVisible(find.text('Online version'), 200);
    expect(find.text('Online version'), findsOneWidget);
  });

  testWidgets('is localized in Italian', (tester) async {
    await _pumpScreen(tester, const Locale('it'));

    expect(find.text('Ultimo aggiornamento: 2 ottobre 2026'), findsOneWidget);
    expect(find.text('1. Titolare del trattamento'), findsOneWidget);
  });
}
