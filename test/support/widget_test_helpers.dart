// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a fully localized, screen-util-initialized
/// `MaterialApp`, matching the shell every real screen runs under
/// (`ScreenUtilInit` in `app.dart`), so widgets using `.w`/`.h`/`.sp`/`.r`
/// and `AppLocalizations.of(context)` work the same as at runtime.
Future<void> pumpLocalizedWidget(WidgetTester tester, Widget child) async {
  // Match the test surface to ScreenUtilInit's designSize (1:1 device pixel
  // ratio) so `.w`/`.h`/`.sp`/`.r` scale to their literal values instead of
  // being stretched by the default 800x600 test surface, which otherwise
  // causes spurious overflow in widgets sized for a real phone width.
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
  // Not pumpAndSettle: some widgets (loaders) run an infinite animation
  // that would never let pumpAndSettle's "no more frames scheduled" wait
  // complete, so it always times out. A couple of plain pumps is enough
  // for the localization delegate and ScreenUtilInit's LayoutBuilder to
  // resolve and the widget tree to settle.
  await tester.pump();
  await tester.pump();
}
