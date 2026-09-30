// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/features/favorites/screens/favorites_screen.dart';
import 'package:qration/l10n/app_localizations.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  late StreamController<List<CodeModel>> stream;

  setUp(() {
    Get.testMode = true;
    stream = StreamController<List<CodeModel>>();
    final repository = MockCodesRepository();
    when(() => repository.getFavoriteCodesStream())
        .thenAnswer((_) => stream.stream);
    when(() => repository.getSyncStatusStream())
        .thenAnswer((_) => const Stream.empty());
    Get.put<CodesRepository>(repository);
    // In the app HomeBinding registers it for the Home route.
    Get.put(FavoritesController());
  });

  tearDown(() async {
    Get.reset();
    await stream.close();
  });

  Future<void> pumpFavorites(WidgetTester tester, {VoidCallback? onCreate}) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    return tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FavoritesScreen(onCreateCode: onCreate),
        ),
      ),
    );
  }

  CodeModel code(String id, String value, CodeSource source) => CodeModel(
        id: id,
        barcode: Barcode(rawValue: value, type: BarcodeType.text),
        date: DateTime(2026, 1, int.parse(id)),
        source: source,
        isFavorite: true,
      );

  testWidgets('no favorites shows the create call to action', (tester) async {
    var createRequests = 0;
    await pumpFavorites(tester, onCreate: () => createRequests++);
    stream.add([]);
    await tester.pump();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(FavoritesScreen)))!;
    await tester.tap(find.text(l10n.favorites_screen_empty_action));
    expect(createRequests, 1);
  });

  testWidgets('favorites are split between the two tabs', (tester) async {
    await pumpFavorites(tester);
    stream.add([
      code('1', 'created one', CodeSource.created),
      code('2', 'scanned one', CodeSource.scanned),
    ]);
    await tester.pump();

    expect(find.text('created one'), findsOneWidget);
    expect(find.text('scanned one'), findsNothing);

    final l10n =
        AppLocalizations.of(tester.element(find.byType(FavoritesScreen)))!;
    await tester.tap(find.text(l10n.favorites_screen_tab_scanned));
    await tester.pumpAndSettle();

    expect(find.text('scanned one'), findsOneWidget);
  });
}
