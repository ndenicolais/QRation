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
import 'package:qration/features/codes/models/code_types.dart';

void main() {
  group('CodeUrl', () {
    test('extracts phone number from a whatsapp deep link', () {
      final url = CodeUrl.fromRawValue('whatsapp://send?phone=393331234567');
      expect(url.toString(), '393331234567');
    });

    test('formats a spotify search query', () {
      final url = CodeUrl.fromRawValue('spotify:search:daft;punk');
      expect(url.toString(), 'Daft - Punk');
    });

    test('keeps a plain url unchanged', () {
      final url = CodeUrl.fromRawValue('https://example.com');
      expect(url.toString(), 'https://example.com');
    });
  });

  group('CodeEmail', () {
    test('parses MATMSG fields', () {
      final email = CodeEmail.fromRawValue(
        r"MATMSG:TO:test@example.com;SUB:Hello;BODY:World\'s best;;",
      );
      expect(email.address, 'test@example.com');
      expect(email.subject, 'Hello');
      expect(email.body, "World's best");
      expect(email.toString(), 'test@example.com\nHello');
    });
  });

  group('CodePhoneNumber', () {
    test('strips the tel: prefix', () {
      final phone = CodePhoneNumber.fromRawValue('tel:+393331234567');
      expect(phone.number, '+393331234567');
      expect(phone.toString(), '+393331234567');
    });
  });

  group('CodeSms', () {
    test('parses SMSTO number and message', () {
      final sms = CodeSms.fromRawValue('SMSTO:+393331234567:Hello there');
      expect(sms.phoneNumber, '+393331234567');
      expect(sms.message, 'Hello there');
    });

    test('falls back to N/A on malformed input', () {
      final sms = CodeSms.fromRawValue('not-a-valid-sms');
      expect(sms.phoneNumber, 'N/A');
      expect(sms.message, 'N/A');
    });
  });

  group('CodeContact', () {
    test('parses a vCard with FN and TEL', () {
      final contact = CodeContact.fromRawValue(
        'BEGIN:VCARD\nFN:Mario Rossi\nTEL:+393331234567\nEMAIL:mario@example.com\nEND:VCARD',
      );
      expect(contact.name, 'Mario');
      expect(contact.surname, 'Rossi');
      expect(contact.phoneNumber, '+393331234567');
      expect(contact.email, 'mario@example.com');
    });

    test('parses a vCard using the N; field', () {
      final contact = CodeContact.fromRawValue(
        'BEGIN:VCARD\nN:Rossi;Mario;;;\nEND:VCARD',
      );
      expect(contact.name, 'Mario');
      expect(contact.surname, 'Rossi');
    });
  });

  group('CodeGeo', () {
    test('parses latitude and longitude', () {
      final geo = CodeGeo.fromRawValue('geo:45.4642,9.1900?z=15');
      expect(geo.latitude, '45.4642');
      expect(geo.longitude, '9.1900');
    });
  });

  group('CodeWifi', () {
    test('parses the strict WIFI: format', () {
      final wifi =
          CodeWifi.fromRawValue('WIFI:T:WPA;S:MyNetwork;P:secret;H:true;');
      expect(wifi.ssid, 'MyNetwork');
      expect(wifi.password, 'secret');
      expect(wifi.authenticationType, 'WPA');
      expect(wifi.hidden, isTrue);
    });

    test('falls back to a lenient key=value parse when out of order', () {
      final wifi =
          CodeWifi.fromRawValue('WIFI:S:MyNetwork;P:secret;T:WPA;H:false');
      expect(wifi.ssid, 'MyNetwork');
      expect(wifi.password, 'secret');
      expect(wifi.authenticationType, 'WPA');
      expect(wifi.hidden, isFalse);
    });

    test('treats the raw value as the ssid when nothing else parses', () {
      final wifi = CodeWifi.fromRawValue('not-a-wifi-code');
      expect(wifi.ssid, 'not-a-wifi-code');
    });
  });

  group('CodeEvent', () {
    test('parses SUMMARY/DTSTART/DTEND/LOCATION and formats dates', () {
      final event = CodeEvent.fromRawValue(
        'SUMMARY:Meeting\nDTSTART:20260301T090000\nDTEND:20260301T100000\nLOCATION:Office',
      );
      expect(event.title, 'Meeting');
      expect(event.location, 'Office');
      expect(event.formattedStartDate, '01/03/2026 09:00');
      expect(event.formattedEndDate, '01/03/2026 10:00');
    });
  });

  group('CodeProduct', () {
    test('extracts the barcode before the separator', () {
      final product = CodeProduct.fromRawValue('8001234567890 - Some Product');
      expect(product.barcode, '8001234567890');
    });

    test('throws on an empty raw value', () {
      expect(() => CodeProduct.fromRawValue(''), throwsFormatException);
    });
  });

  group('CodeISBN', () {
    test('keeps the raw value as the isbn', () {
      final isbn = CodeISBN.fromRawValue('9780134685991');
      expect(isbn.isbn, '9780134685991');
      expect(isbn.toRawValue(), '9780134685991');
    });

    test('throws on an empty raw value', () {
      expect(() => CodeISBN.fromRawValue(''), throwsFormatException);
    });
  });

  group('convertToCustomFormat (top-level)', () {
    test('converts a dd/MM/yyyy HH:mm string to ISO-like format', () {
      expect(convertToCustomFormat('01/03/2026 09:00'), '2026-03-01T09:00:00');
    });

    test('returns the input unchanged when it is not slash-separated', () {
      expect(convertToCustomFormat('20260301T090000'), '20260301T090000');
    });
  });
}
