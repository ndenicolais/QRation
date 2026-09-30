// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qration/core/utils/validator.dart';

Future<BuildContext> _pumpContext(WidgetTester tester) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          capturedContext = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return capturedContext;
}

void main() {
  group('ExtString validators', () {
    testWidgets('rejects an empty name', (tester) async {
      final context = await _pumpContext(tester);
      expect(''.isValidName(context), isFalse);
    });

    testWidgets('accepts a non-empty name', (tester) async {
      final context = await _pumpContext(tester);
      expect('Mario'.isValidName(context), isTrue);
    });

    testWidgets('rejects an email missing "@" or "."', (tester) async {
      final context = await _pumpContext(tester);
      expect('invalid-email'.isValidEmail(context), isFalse);
    });

    testWidgets('accepts a well-formed email', (tester) async {
      final context = await _pumpContext(tester);
      expect('user@example.com'.isValidEmail(context), isTrue);
    });

    testWidgets('rejects a password missing required character classes',
        (tester) async {
      final context = await _pumpContext(tester);
      expect('short'.isValidPassword(context), isFalse);
    });

    testWidgets(
        'accepts a password with upper/lower/digit/special and min length',
        (tester) async {
      final context = await _pumpContext(tester);
      expect('Password1!'.isValidPassword(context), isTrue);
    });
  });
}
