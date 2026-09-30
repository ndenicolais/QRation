// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter_test/flutter_test.dart';
import 'package:qration/features/codes/widgets/code_create/generate_button.dart';

import '../../../../support/widget_test_helpers.dart';

void main() {
  testWidgets('shows the label and invokes onPressed when tapped',
      (tester) async {
    var taps = 0;

    await pumpLocalizedWidget(
      tester,
      GenerateButton(label: 'Generate', onPressed: () => taps++),
    );

    expect(find.text('Generate'), findsOneWidget);

    await tester.tap(find.text('Generate'));
    await tester.pump();

    expect(taps, 1);
  });
}
