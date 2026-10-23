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
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qration/app.dart';
import 'package:qration/core/bindings/app_binding.dart';
import 'package:qration/core/constants/app_version.dart';

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

  LicenseRegistry.addLicense(_fontLicenses);

  AppBinding().dependencies();
  runApp(QrationApp(initialLocale: await QrationApp.loadSavedLocale()));
}

/// Bundled fonts are not pub packages, so their licenses must be registered
/// by hand to appear in `showLicensePage`.
Stream<LicenseEntry> _fontLicenses() async* {
  final ofl = await rootBundle.loadString('assets/fonts/OFL.txt');
  yield LicenseEntryWithLineBreaks(['Montserrat'], ofl);
}
