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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/routes/app_pages.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_theme.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrationApp extends StatelessWidget {
  const QrationApp({super.key});

  Future<Locale?> _resolveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code');
    if (code != null && code.isNotEmpty) {
      return Locale(code);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return LayoutBuilder(
      builder: (_, constraints) => ScreenUtilInit(
        designSize: Size(
          constraints.maxWidth > 0 ? constraints.maxWidth : 390,
          constraints.maxHeight > 0 ? constraints.maxHeight : 844,
        ),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (_, __) => FutureBuilder<Locale?>(
          future: _resolveLocale(),
          builder: (_, snap) => Obx(
            () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'QRation',
              theme: AppTheme.lightTheme(
                primary: themeController.currentAccent.light,
              ),
              darkTheme: AppTheme.darkTheme(
                primary: themeController.currentAccent.dark,
              ),
              themeMode:
                  themeController.isDark ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: snap.data,
              supportedLocales: L10n.all,
              getPages: AppPages.pages,
              unknownRoute: AppPages.unknownRoute,
              initialRoute: AppRoutes.splash,
            ),
          ),
        ),
      ),
    );
  }
}
