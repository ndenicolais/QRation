// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais
//
// Real device/emulator integration test (uses `IntegrationTestWidgetsFlutterBinding`,
// unlike the `flutter_test`-only tests under test/integration/). Firebase itself
// is not booted here (that needs a provisioned Firebase project on the test
// device/emulator); instead the app shell (theme + localization + GetX DI) is
// wired exactly like `main.dart`/`app.dart`, with a mocked `CodesRepository`
// standing in for the Firestore-backed `CodesService`.
//
// Run on a connected device/emulator with:
//   flutter test integration_test/database_flow_test.dart

import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/settings/controllers/database_controller.dart';
import 'package:qration/features/settings/widgets/statistics_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'database statistics load and render on a real device/emulator',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      Get.testMode = true;

      final repository = MockCodesRepository();
      Get.put<CodesRepository>(repository);
      when(() => repository.countAllCodes()).thenAnswer((_) async => 3);
      when(() => repository.countCodesBySource(CodeSource.created))
          .thenAnswer((_) async => 3);
      when(() => repository.countCodesBySource(CodeSource.scanned))
          .thenAnswer((_) async => 0);
      when(() => repository.countCodesByType(CodeSource.created))
          .thenAnswer((_) async => {'text': 3});
      when(() => repository.countSocialCodesByType(CodeSource.created))
          .thenAnswer((_) async => {});
      when(() => repository.countCodesByType(CodeSource.scanned))
          .thenAnswer((_) async => {});
      when(() => repository.countSocialCodesByType(CodeSource.scanned))
          .thenAnswer((_) async => {});

      Get.put(ThemeController());
      final controller = Get.put(DatabaseController());

      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : StatisticsSection(
                      totalCodes: controller.totalCodes.value,
                      createdCodesCount: controller.createdCodesCount.value,
                      scannedCodesCount: controller.scannedCodesCount.value,
                      standardCodesByCreated:
                          controller.standardCodesByCreated.value,
                      socialCodesByCreated:
                          controller.socialCodesByCreated.value,
                      standardCodesByScanned:
                          controller.standardCodesByScanned.value,
                      socialCodesByScanned:
                          controller.socialCodesByScanned.value,
                    ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsSection), findsOneWidget);
      expect(find.text('3'), findsWidgets);

      Get.reset();
    },
  );
}
