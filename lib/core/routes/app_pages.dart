// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/codes/bindings/code_bindings.dart';
import 'package:qration/features/codes/bindings/scanner_binding.dart';
import 'package:qration/features/home/bindings/home_binding.dart';
import 'package:qration/features/settings/bindings/settings_binding.dart';
import 'package:qration/features/auth/screens/login_screen.dart';
import 'package:qration/features/auth/screens/reset_password_screen.dart';
import 'package:qration/features/auth/screens/signup_screen.dart';
import 'package:qration/features/codes/screens/code_create_social_screen.dart';
import 'package:qration/features/codes/screens/code_create_standard_screen.dart';
import 'package:qration/features/codes/screens/code_details_screen.dart';
import 'package:qration/features/codes/screens/code_scanner_screen.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/home/screens/home_screen.dart';
import 'package:qration/features/onboarding/screens/onboarding_screen.dart';
import 'package:qration/features/settings/screens/database_screen.dart';
import 'package:qration/features/settings/screens/info_screen.dart';
import 'package:qration/features/settings/screens/privacy_policy_screen.dart';
import 'package:qration/features/settings/screens/settings_screen.dart';
import 'package:qration/features/settings/screens/support_screen.dart';
import 'package:qration/features/splash/screens/splash_screen.dart';
import 'package:qration/features/user/screens/delete_account_screen.dart';
import 'package:qration/features/user/screens/user_screen.dart';
import 'package:qration/features/welcome/screens/welcome_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      binding: HomeBinding(),
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.scanner,
      binding: ScannerBinding(),
      page: () => const ScannerScreen(),
    ),
    GetPage(
      name: AppRoutes.codeCreateStandard,
      binding: CodeCreateStandardBinding(),
      page: () {
        final arguments = Get.arguments;
        if (arguments is! BarcodeType) return const HomeScreen();
        return CodeCreateStandardScreen(type: arguments);
      },
    ),
    GetPage(
      name: AppRoutes.codeCreateSocial,
      binding: CodeCreateSocialBinding(),
      page: () {
        final arguments = Get.arguments;
        if (arguments is! CodeSocial) return const HomeScreen();
        return CodeCreateSocialScreen(socialMedia: arguments);
      },
    ),
    GetPage(
      name: AppRoutes.codeDetails,
      binding: CodeDetailsBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
      page: () {
        final arguments = Get.arguments;
        if (arguments is! CodeModel) return const HomeScreen();
        return CodeDetailsScreen(code: arguments);
      },
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => const UserScreen(),
    ),
    GetPage(
      name: AppRoutes.deleteAccount,
      page: () => const DeleteAccountScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      binding: SettingsBinding(),
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsDatabase,
      binding: DatabaseBinding(),
      page: () => const DatabaseScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsInfo,
      page: () => const InfoScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsSupport,
      page: () => const SupportScreen(),
    ),
  ];

  static final GetPage unknownRoute = GetPage(
    name: AppRoutes.home,
    page: () => const HomeScreen(),
  );
}
