// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

// Runs with the default test font on purpose: the contrast guideline reads
// colors from a screenshot and is only reliable with its solid glyphs, the
// anti-aliased edges of a real font report contrast far lower than it is.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'a11y_harness.dart';

void main() {
  setUp(() async {
    registerA11yDependencies();
    await pumpEventQueue();
  });
  tearDown(Get.reset);

  for (final MapEntry(key: name, value: build) in a11yScreens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name (${brightness.name}) meets a11y guidelines',
          (tester) async {
        final semantics = tester.ensureSemantics();
        await pumpA11yScreen(tester, build(), brightness: brightness);
        // Evaluated one by one (rather than with expectLater) so a failure
        // lists the problems of every guideline, not just the first.
        final problems = <String>[];
        for (final guideline in [
          androidTapTargetGuideline,
          labeledTapTargetGuideline,
          textContrastGuideline,
        ]) {
          final result = await guideline.evaluate(tester);
          if (!result.passed) problems.add(result.reason!);
        }
        semantics.dispose();
        expect(problems, isEmpty, reason: problems.join('\n'));
      });
    }
  }
}
