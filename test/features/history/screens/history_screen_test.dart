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
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/features/history/screens/history_screen.dart';
import 'package:qration/features/history/widgets/history_filter_sheet.dart';
import 'package:qration/l10n/app_localizations.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  late StreamController<List<CodeModel>> stream;

  setUp(() {
    Get.testMode = true;
    stream = StreamController<List<CodeModel>>();
    final repository = MockCodesRepository();
    when(() => repository.getCodesStream()).thenAnswer((_) => stream.stream);
    when(() => repository.getSyncStatusStream())
        .thenAnswer((_) => const Stream.empty());
    Get.put<CodesRepository>(repository);
    // In the app HomeBinding registers it for the Home route.
    Get.put(HistoryController());
  });

  tearDown(() async {
    Get.reset();
    await stream.close();
  });

  Future<void> pumpHistory(WidgetTester tester,
      {VoidCallback? onScanNow}) async {
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
          home: HistoryScreen(onScanNow: onScanNow),
        ),
      ),
    );
    await tester.pump();
  }

  CodeModel code(String id, String value) => CodeModel(
        id: id,
        barcode: Barcode(rawValue: value, type: BarcodeType.text),
        date: DateTime(2026, 1, int.parse(id)),
        source: CodeSource.scanned,
      );

  testWidgets('renders codes, selection mode and select all', (tester) async {
    await pumpHistory(tester);

    stream.add([code('1', 'first code'), code('2', 'second code')]);
    await tester.pump();

    expect(find.text('first code'), findsOneWidget);
    expect(find.text('second code'), findsOneWidget);

    final l10n =
        AppLocalizations.of(tester.element(find.byType(HistoryScreen)))!;
    await tester.tap(find.byTooltip(l10n.history_screen_tooltip_select_mode));
    await tester.pumpAndSettle();
    expect(find.byType(Checkbox), findsNWidgets(2));
    // The search field is replaced by the contextual selection bar.
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byTooltip(l10n.history_screen_select_all));
    await tester.pump();
    expect(
        find.text('2 ${l10n.history_screen_selected_count}'), findsOneWidget);

    await tester
        .tap(find.byTooltip(l10n.history_screen_tooltip_close_selection));
    await tester.pumpAndSettle();
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('long press selects the pressed code', (tester) async {
    await pumpHistory(tester);
    stream.add([code('1', 'first code'), code('2', 'second code')]);
    await tester.pump();

    await tester.longPress(find.text('second code'));
    await tester.pumpAndSettle();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(HistoryScreen)))!;
    expect(
        find.text('1 ${l10n.history_screen_selected_count}'), findsOneWidget);
    final checked = tester
        .widgetList<Checkbox>(find.byType(Checkbox))
        .where((c) => c.value == true);
    expect(checked.length, 1);
  });

  testWidgets('filter sheet filters live and shows the active count',
      (tester) async {
    await pumpHistory(tester);
    stream.add([
      code('1', 'first code'),
      CodeModel(
        id: '2',
        barcode: const Barcode(rawValue: 'tel:123', type: BarcodeType.phone),
        date: DateTime(2026, 1, 2),
        source: CodeSource.created,
      ),
    ]);
    await tester.pump();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(HistoryScreen)))!;
    await tester.tap(find.byTooltip(l10n.history_screen_tooltip_filter));
    await tester.pumpAndSettle();
    expect(find.text(l10n.history_filter_sheet_title), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(HistoryFilterSheet),
      matching: find.text(l10n.history_screen_filter_created),
    ));
    await tester.pump();
    await tester.tap(find.text(l10n.history_filter_sheet_show_results));
    await tester.pumpAndSettle();

    expect(find.text('first code'), findsNothing);
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isTrue);
    expect((badge.label! as Text).data, '1');

    await tester.tap(find.byTooltip(l10n.history_screen_tooltip_filter));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.history_screen_clear_filters));
    await tester.pump();
    await tester.tap(find.text(l10n.history_filter_sheet_show_results));
    await tester.pumpAndSettle();

    expect(find.text('first code'), findsOneWidget);
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
  });

  testWidgets('empty history offers to scan', (tester) async {
    var scanRequests = 0;
    await pumpHistory(tester, onScanNow: () => scanRequests++);

    stream.add([]);
    await tester.pump();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(HistoryScreen)))!;
    expect(find.text(l10n.history_screen_empty_state), findsOneWidget);

    await tester.tap(find.text(l10n.history_screen_empty_action));
    expect(scanRequests, 1);
  });

  testWidgets('no matches offers to clear the filters', (tester) async {
    await pumpHistory(tester);

    stream.add([code('1', 'first code')]);
    await tester.pump();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(HistoryScreen)))!;
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(l10n.history_screen_empty_filtered), findsOneWidget);

    await tester.tap(find.text(l10n.history_screen_clear_filters));
    await tester.pump();

    expect(find.text('first code'), findsOneWidget);
    expect(find.text('zzz'), findsNothing);
    // Let the search debounce re-armed by clearing settle.
    await tester.pump(const Duration(milliseconds: 350));
  });
}
