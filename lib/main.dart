// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qration/app.dart';
import 'package:qration/core/constants/app_version.dart';
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/codes/services/codes_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final packageInfo = await PackageInfo.fromPlatform();
  AppVersion.current = packageInfo.version;

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Get.put(ThemeController());
  Get.put(ScannerPreferencesController());
  Get.put<CodesRepository>(CodesService());
  runApp(const QrationApp());
}
