// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qration/core/utils/isbn_formatter.dart';

TextEditingValue _format(String text) {
  return ISBNFormatter().formatEditUpdate(
    TextEditingValue.empty,
    TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length)),
  );
}

void main() {
  group('ISBNFormatter', () {
    test('formats a 10-digit ISBN with dashes', () {
      expect(_format('0306406152').text, '0-3064-0615-2');
    });

    test('formats a 13-digit ISBN with dashes', () {
      expect(_format('9780306406157').text, '978-03-0640-615-7');
    });

    test('strips non-digit characters before formatting', () {
      expect(_format('978-0306406157').text, '978-03-0640-615-7');
    });

    test('leaves partial input unformatted below the first threshold', () {
      expect(_format('9').text, '9');
    });

    test('collapses the cursor to the end of the formatted text', () {
      expect(
          _format('0306406152').selection.baseOffset, '0-3064-0615-2'.length);
    });
  });
}
