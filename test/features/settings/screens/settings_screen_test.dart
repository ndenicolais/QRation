// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/settings/controllers/settings_controller.dart';
import 'package:qration/features/settings/screens/settings_screen.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    Get.put(ThemeController());
    Get.put(ScannerPreferencesController());
    Get.put(AuthController(
      auth: MockFirebaseAuth(),
      firestore: FakeFirebaseFirestore(),
      googleSignIn: MockGoogleSignIn(),
      navigateTo: (_) {},
    ));
    Get.put(SettingsController());
    // Let ThemeController and ScannerPreferencesController finish loading
    // their stored values before the test interacts with the screen.
    await pumpEventQueue();
  });

  tearDown(Get.reset);

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SettingsScreen(),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the language actually in use', (tester) async {
    await pumpSettings(tester);

    final l10n =
        AppLocalizations.of(tester.element(find.byType(SettingsScreen)))!;
    final segmented = tester.widget<SegmentedButton<String>>(
      find.byType(SegmentedButton<String>),
    );
    expect(segmented.selected, {'it'});
    expect(find.text(l10n.settings_subtitle_language_option_italian),
        findsOneWidget);
  });

  testWidgets('scan switches update the shared preferences controller',
      (tester) async {
    await pumpSettings(tester);

    final beep = find.byType(Switch).first;
    expect(tester.widget<Switch>(beep).value, isFalse);

    await tester.tap(beep);
    await tester.pump();

    expect(Get.find<ScannerPreferencesController>().beepEnabled, isTrue);
    expect(tester.widget<Switch>(find.byType(Switch).first).value, isTrue);
  });

  testWidgets('theme selector switches to dark mode', (tester) async {
    await pumpSettings(tester);

    final l10n =
        AppLocalizations.of(tester.element(find.byType(SettingsScreen)))!;
    // The test font is wider than Montserrat: bring the segment into view
    // inside its horizontal scroll first.
    final dark = find.text(l10n.settings_subtitle_theme_option_dark);
    await tester.ensureVisible(dark);
    await tester.tap(dark);
    await tester.pump();

    expect(Get.find<ThemeController>().themeMode, ThemeMode.dark);
  });
}
