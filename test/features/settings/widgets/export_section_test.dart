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
import 'package:qration/features/settings/widgets/export_section.dart';

import '../../../support/widget_test_helpers.dart';

void main() {
  testWidgets('tapping each export card triggers its own callback',
      (tester) async {
    var pdfTaps = 0;
    var excelTaps = 0;
    var csvTaps = 0;

    await pumpLocalizedWidget(
      tester,
      ExportSection(
        onPdf: () => pdfTaps++,
        onExcel: () => excelTaps++,
        onCsv: () => csvTaps++,
      ),
    );

    final inkWells = find.byType(InkWell);
    expect(inkWells, findsNWidgets(3));

    await tester.tap(inkWells.at(0));
    await tester.tap(inkWells.at(1));
    await tester.tap(inkWells.at(2));
    await tester.tap(inkWells.at(2));

    expect(pdfTaps, 1);
    expect(excelTaps, 1);
    expect(csvTaps, 2);
  });
}
