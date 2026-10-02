// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

// Shared setup for the accessibility tests: the screens to check, their
// fake dependencies and a pump helper with theme and text scale.

import 'dart:async';
import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/theme/app_theme.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/auth/screens/login_screen.dart';
import 'package:qration/features/auth/screens/reset_password_screen.dart';
import 'package:qration/features/auth/screens/signup_screen.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/screens/code_create_standard_screen.dart';
import 'package:qration/features/codes/screens/code_create_types_screen.dart';
import 'package:qration/features/codes/screens/code_details_screen.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/features/favorites/screens/favorites_screen.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/features/history/screens/history_screen.dart';
import 'package:qration/features/onboarding/screens/onboarding_screen.dart';
import 'package:qration/features/settings/controllers/settings_controller.dart';
import 'package:qration/features/settings/screens/info_screen.dart';
import 'package:qration/features/settings/screens/privacy_policy_screen.dart';
import 'package:qration/features/settings/screens/settings_screen.dart';
import 'package:qration/features/settings/screens/support_screen.dart';
import 'package:qration/features/user/screens/delete_account_screen.dart';
import 'package:qration/features/welcome/screens/welcome_screen.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockGoogleSignIn extends Mock implements GoogleSignIn {}

class _MockCodesRepository extends Mock implements CodesRepository {}

/// Loads the bundled Montserrat so text is measured with the real font
/// instead of the wide test font, which would report overflows that never
/// happen on a device.
Future<void> loadMontserrat() async {
  final loader = FontLoader('Montserrat')
    ..addFont(_fontAsset('assets/fonts/Montserrat.ttf'))
    ..addFont(_fontAsset('assets/fonts/Montserrat-Bold.ttf'));
  await loader.load();
}

Future<ByteData> _fontAsset(String path) async =>
    ByteData.sublistView(await File(path).readAsBytes());

CodeModel _code(String id, String value, {bool favorite = false}) => CodeModel(
      id: id,
      barcode: Barcode(rawValue: value, type: BarcodeType.text),
      date: DateTime(2026, 1, int.parse(id)),
      source: CodeSource.scanned,
      isFavorite: favorite,
    );

void registerA11yDependencies() {
  Get.testMode = true;
  SharedPreferences.setMockInitialValues({});
  final codes = [
    _code('1', 'https://example.com/a-fairly-long-link', favorite: true),
    _code('2', 'Plain text code', favorite: true),
  ];
  final repository = _MockCodesRepository();
  when(() => repository.getCodesStream())
      .thenAnswer((_) => Stream.value(codes));
  when(() => repository.getFavoriteCodesStream())
      .thenAnswer((_) => Stream.value(codes));
  when(() => repository.getSyncStatusStream())
      .thenAnswer((_) => const Stream.empty());
  Get.put<CodesRepository>(repository);
  Get.put(ThemeController());
  Get.put(ScannerPreferencesController());
  Get.put(AuthController(
    auth: MockFirebaseAuth(),
    firestore: FakeFirebaseFirestore(),
    googleSignIn: _MockGoogleSignIn(),
    navigateTo: (_) {},
  ));
  Get.put(SettingsController());
  Get.put(HistoryController());
  Get.put(FavoritesController());
  Get.put(CodeDetailsController(codes.first));
  Get.put(CodeCreateStandardController(type: BarcodeType.url));
}

/// Every screen that can be built without a camera or a signed-in user,
/// with the dependencies registered by [registerA11yDependencies].
final a11yScreens = <String, Widget Function()>{
  'Welcome': () => const WelcomeScreen(),
  'Onboarding': () => const OnboardingScreen(),
  'Login': () => const LoginScreen(),
  'Signup': () => const SignupScreen(),
  'ResetPassword': () => const ResetPasswordScreen(),
  'History': () => HistoryScreen(onScanNow: () {}),
  'Favorites': () => FavoritesScreen(onCreateCode: () {}),
  'CreateTypes': () => CodeCreateTypesScreen(),
  'CreateStandard': () => const CodeCreateStandardScreen(type: BarcodeType.url),
  'Details': () => CodeDetailsScreen(code: _code('1', 'https://example.com')),
  'Settings': () => const SettingsScreen(),
  'Info': () => const InfoScreen(),
  'Support': () => const SupportScreen(),
  'PrivacyPolicy': () => const PrivacyPolicyScreen(),
  'DeleteAccount': () => const DeleteAccountScreen(),
};

Future<void> pumpA11yScreen(
  WidgetTester tester,
  Widget screen, {
  required Brightness brightness,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    GetMaterialApp(
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode:
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: screen,
    ),
  );
  // Plain pumps, not pumpAndSettle: some screens run looping animations.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}
