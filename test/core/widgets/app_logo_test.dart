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
import 'package:qration/core/widgets/app_logo.dart';

void main() {
  Future<Image> pumpLogo(
      WidgetTester tester, Widget logo, ThemeData theme) async {
    await tester
        .pumpWidget(MaterialApp(theme: theme, home: Center(child: logo)));
    return tester.widget<Image>(find.byType(Image));
  }

  testWidgets('is tinted with the theme primary color', (tester) async {
    final theme = ThemeData(
      colorScheme: const ColorScheme.dark(primary: Color(0xFFCCA775)),
    );
    final image = await pumpLogo(tester, const AppLogo(size: 64), theme);

    expect(image.color, const Color(0xFFCCA775));
    expect(image.colorBlendMode, BlendMode.srcIn);
    expect(image.width, 64);
  });

  testWidgets('an explicit color overrides the theme', (tester) async {
    final image = await pumpLogo(
      tester,
      const AppLogo(color: Colors.white),
      ThemeData(),
    );

    expect(image.color, Colors.white);
  });
}
