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
import 'package:qration/core/utils/rescan_guard.dart';

void main() {
  late DateTime now;
  late RescanGuard guard;

  setUp(() {
    now = DateTime(2026, 1, 1, 12);
    guard = RescanGuard(
      cooldown: const Duration(seconds: 2),
      clock: () => now,
    );
  });

  test('accepts the first detection', () {
    expect(guard.accept('A'), isTrue);
  });

  test('ignores the same code while it stays in frame', () {
    guard.accept('A');
    for (var i = 0; i < 10; i++) {
      now = now.add(const Duration(milliseconds: 500));
      expect(guard.accept('A'), isFalse);
    }
  });

  test('accepts the same code again after it left the frame', () {
    guard.accept('A');
    now = now.add(const Duration(seconds: 2));
    expect(guard.accept('A'), isTrue);
  });

  test('accepts a different code immediately', () {
    guard.accept('A');
    now = now.add(const Duration(milliseconds: 100));
    expect(guard.accept('B'), isTrue);
  });

  test('touch restarts the cooldown for the last code', () {
    guard.accept('A');
    now = now.add(const Duration(seconds: 5));
    guard.touch();
    now = now.add(const Duration(seconds: 1));
    expect(guard.accept('A'), isFalse);
  });

  test('touch before any scan has no effect', () {
    guard.touch();
    expect(guard.accept('A'), isTrue);
  });
}
