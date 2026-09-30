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
import 'package:qration/core/utils/code_type_conversion.dart';

void main() {
  group('CodeTypeConversion.detectBarcodeType', () {
    test('detects URLs, including whatsapp/spotify deep links', () {
      expect(CodeTypeConversion.detectBarcodeType('https://example.com'),
          BarcodeType.url);
      expect(CodeTypeConversion.detectBarcodeType('www.example.com'),
          BarcodeType.url);
      expect(CodeTypeConversion.detectBarcodeType('whatsapp://send?phone=1'),
          BarcodeType.url);
      expect(CodeTypeConversion.detectBarcodeType('spotify:track:123'),
          BarcodeType.url);
    });

    test('detects email, phone and SMS payloads', () {
      expect(CodeTypeConversion.detectBarcodeType('MATMSG:TO:a@b.com;;'),
          BarcodeType.email);
      expect(CodeTypeConversion.detectBarcodeType('tel:+391234567'),
          BarcodeType.phone);
      expect(CodeTypeConversion.detectBarcodeType('SMSTO:+391234567:hi'),
          BarcodeType.sms);
    });

    test('detects contact, location, wifi and calendar payloads', () {
      expect(CodeTypeConversion.detectBarcodeType('BEGIN:VCARD\nEND:VCARD'),
          BarcodeType.contactInfo);
      expect(CodeTypeConversion.detectBarcodeType('geo:45.0,9.0'),
          BarcodeType.geo);
      expect(CodeTypeConversion.detectBarcodeType('WIFI:S:net;T:WPA;P:pass;;'),
          BarcodeType.wifi);
      expect(
          CodeTypeConversion.detectBarcodeType(
              'BEGIN:VCALENDAR\nEND:VCALENDAR'),
          BarcodeType.calendarEvent);
    });

    test('detects a 13-digit numeric product barcode', () {
      expect(CodeTypeConversion.detectBarcodeType('8001234567890'),
          BarcodeType.product);
    });

    test('detects a 10-digit ISBN', () {
      expect(
          CodeTypeConversion.detectBarcodeType('0306406152'), BarcodeType.isbn);
    });

    test('falls back to text for unrecognized content', () {
      expect(CodeTypeConversion.detectBarcodeType('just some text'),
          BarcodeType.text);
    });
  });
}
