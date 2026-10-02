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
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a fully localized `MaterialApp`, so widgets using
/// `AppLocalizations.of(context)` work the same as at runtime.
Future<void> pumpLocalizedWidget(WidgetTester tester, Widget child) async {
  // Use a phone-sized surface (1:1 device pixel ratio) instead of the
  // default 800x600 one, so layouts are checked at a real phone width.
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
  // Not pumpAndSettle: some widgets (loaders) run an infinite animation
  // that would never let pumpAndSettle's "no more frames scheduled" wait
  // complete, so it always times out. A couple of plain pumps is enough
  // for the localization delegate to resolve and the widget tree to settle.
  await tester.pump();
  await tester.pump();
}
