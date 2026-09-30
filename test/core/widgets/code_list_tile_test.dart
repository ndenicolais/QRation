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
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/widgets/code_list_tile.dart';
import 'package:qration/features/codes/models/code_model.dart';

import '../../support/widget_test_helpers.dart';

void main() {
  final code = CodeModel(
    id: '1',
    barcode: const Barcode(rawValue: 'hello', type: BarcodeType.text),
    date: DateTime(2026, 3, 4, 5, 6),
    source: CodeSource.scanned,
  );

  testWidgets('shows content and date, tapping the card opens details',
      (tester) async {
    var taps = 0;
    await pumpLocalizedWidget(
      tester,
      CodeListTile(code: code, onTap: () => taps++),
    );

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('04/03/2026 05:06'), findsOneWidget);
    expect(find.text('Scanned'), findsNothing);
    expect(find.byType(Checkbox), findsNothing);

    await tester.tap(find.text('hello'));
    await tester.tap(find.byType(IconButton));
    expect(taps, 2);
  });

  testWidgets('showSource adds the source label', (tester) async {
    await pumpLocalizedWidget(
      tester,
      CodeListTile(code: code, onTap: () {}, showSource: true),
    );

    expect(find.text('Scanned'), findsOneWidget);
  });

  testWidgets('selectable mode toggles selection instead of opening',
      (tester) async {
    var taps = 0;
    final changes = <bool>[];
    await pumpLocalizedWidget(
      tester,
      CodeListTile(
        code: code,
        onTap: () => taps++,
        selectable: true,
        selected: false,
        onSelectedChanged: changes.add,
      ),
    );

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(IconButton), findsNothing);

    await tester.tap(find.text('hello'));
    await tester.tap(find.byType(Checkbox));

    expect(taps, 0);
    expect(changes, [true, true]);
  });
}
