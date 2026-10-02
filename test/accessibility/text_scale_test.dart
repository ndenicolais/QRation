// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

// Uses the real Montserrat: the default test font draws every glyph as a
// wide square and would report overflows that never happen on a device.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'a11y_harness.dart';

void main() {
  setUpAll(loadMontserrat);
  setUp(() async {
    registerA11yDependencies();
    await pumpEventQueue();
  });
  tearDown(Get.reset);

  for (final MapEntry(key: name, value: build) in a11yScreens.entries) {
    for (final scale in [1.5, 2.0]) {
      testWidgets('$name has no overflow at text scale $scale', (tester) async {
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) {
          // "Row:file:///…/lib/x.dart:12:7" — the widget that overflowed.
          final source = RegExp(r'\w+:file:///\S*?/lib/(\S+\.dart:\d+)')
              .firstMatch(details.toString());
          errors.add('${details.exceptionAsString().split('\n').first}'
              ' (${source?.group(1) ?? 'unknown source'})');
        };
        try {
          await pumpA11yScreen(tester, build(),
              brightness: Brightness.light, textScale: scale);
        } finally {
          FlutterError.onError = previous;
        }
        expect(errors, isEmpty);
      });
    }
  }
}
