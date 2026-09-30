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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/utils/code_type_body.dart';
import 'package:qration/features/codes/models/code_model.dart';

CodeModel _codeWith(String? rawValue, BarcodeType type) {
  return CodeModel(
    id: 'id',
    barcode: Barcode(rawValue: rawValue, type: type),
    date: DateTime(2026, 1, 1),
    source: CodeSource.scanned,
  );
}

void main() {
  group('getContentBody', () {
    test('extracts the phone number from a WhatsApp deep link', () {
      final body = getContentBody(
        _codeWith('whatsapp://send?phone=393331234567', BarcodeType.url),
      );
      expect(body.formattedContent, '393331234567');
      expect(body.type, BarcodeType.text);
    });

    test('formats a Spotify search deep link into a readable title', () {
      final body = getContentBody(
        _codeWith('spotify:search:blinding lights;the weeknd', BarcodeType.url),
      );
      expect(body.formattedContent, 'Blinding Lights - The Weeknd');
      expect(body.type, BarcodeType.text);
    });

    test('passes plain text content through unchanged', () {
      final body = getContentBody(_codeWith('hello world', BarcodeType.text));
      expect(body.formattedContent, 'hello world');
      expect(body.type, BarcodeType.text);
    });

    test('formats email content via CodeEmail', () {
      final body = getContentBody(
        _codeWith('MATMSG:TO:test@example.com;SUB:Hi;;', BarcodeType.email),
      );
      expect(body.type, BarcodeType.email);
      expect(body.formattedContent, isNotEmpty);
    });

    test('formats phone content via CodePhoneNumber', () {
      final body = getContentBody(
        _codeWith('TEL:+393331234567', BarcodeType.phone),
      );
      expect(body.type, BarcodeType.phone);
      expect(body.formattedContent, isNotEmpty);
    });

    test('formats wifi content via CodeWifi', () {
      final body = getContentBody(
        _codeWith('WIFI:T:WPA;S:MyNetwork;P:password;;', BarcodeType.wifi),
      );
      expect(body.type, BarcodeType.wifi);
      expect(body.formattedContent, isNotEmpty);
    });

    test('falls back to "N/A" when rawValue is null', () {
      final body = getContentBody(_codeWith(null, BarcodeType.text));
      expect(body.formattedContent, 'N/A');
      expect(body.type, BarcodeType.text);
    });

    test('marks unrecognized barcode types as unknown', () {
      final body = getContentBody(_codeWith('raw', BarcodeType.driverLicense));
      expect(body.type, BarcodeType.unknown);
      expect(body.formattedContent, 'raw');
    });
  });
}
