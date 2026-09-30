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
import 'package:qration/core/utils/code_social_template.dart';
import 'package:qration/features/codes/models/code_model.dart';

void main() {
  group('createCodeSocialTemplate', () {
    test('recognizes a YouTube link', () {
      final code =
          createCodeSocialTemplate('https://www.youtube.com/watch?v=1');
      expect(code.socialMedia?.name, 'YouTube');
    });

    test('recognizes a WhatsApp deep link', () {
      final code = createCodeSocialTemplate('whatsapp://send?phone=391234567');
      expect(code.socialMedia?.name, 'WhatsApp');
    });

    test('falls back to a generic Link for unrecognized URLs', () {
      final code = createCodeSocialTemplate('https://example.com');
      expect(code.socialMedia?.name, 'Link');
    });

    test('always marks the generated code as scanned', () {
      final code = createCodeSocialTemplate('https://www.instagram.com/user');
      expect(code.source, CodeSource.scanned);
    });
  });
}
