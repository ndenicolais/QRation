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
import 'package:qration/core/widgets/section_card.dart';

import '../../support/widget_test_helpers.dart';

void main() {
  testWidgets('renders the title, icon and child content', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const SectionCard(
        title: 'My Section',
        icon: Icons.star,
        child: Text('Child content'),
      ),
    );

    expect(find.text('My Section'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('Child content'), findsOneWidget);
  });
}
