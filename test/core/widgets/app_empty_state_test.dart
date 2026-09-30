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
import 'package:qration/core/widgets/app_empty_state.dart';

import '../../support/widget_test_helpers.dart';

void main() {
  testWidgets('without an action shows only icon and message', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const AppEmptyState(message: 'Nothing here', icon: Icons.inbox),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('label without callback shows no button', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const AppEmptyState(
        message: 'Nothing here',
        icon: Icons.inbox,
        actionLabel: 'Do it',
      ),
    );

    expect(find.text('Do it'), findsNothing);
  });

  testWidgets('shows the call to action and invokes it', (tester) async {
    var taps = 0;
    await pumpLocalizedWidget(
      tester,
      AppEmptyState(
        message: 'Nothing here',
        icon: Icons.inbox,
        actionLabel: 'Do it',
        onAction: () => taps++,
      ),
    );

    await tester.tap(find.text('Do it'));
    expect(taps, 1);
  });
}
