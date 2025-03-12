import 'package:mobile_scanner/mobile_scanner.dart';

class CodeTypeConversion {
  static BarcodeType detectBarcodeType(String rawValue) {
    if (rawValue.startsWith('whatsapp://') || rawValue.startsWith('spotify:')) {
      return BarcodeType.url;
    }

    if (rawValue.startsWith('www') || rawValue.startsWith('http')) {
      return BarcodeType.url;
    }

    if (rawValue.startsWith('MATMSG:')) {
      return BarcodeType.email;
    }

    if (rawValue.startsWith('tel:')) {
      return BarcodeType.phone;
    }

    if (rawValue.startsWith('SMSTO:')) {
      return BarcodeType.sms;
    }

    if (rawValue.startsWith('BEGIN:VCARD')) {
      return BarcodeType.contactInfo;
    }

    if (rawValue.startsWith('geo:')) {
      return BarcodeType.geo;
    }

    if (rawValue.startsWith('WIFI:')) {
      return BarcodeType.wifi;
    }

    if (rawValue.startsWith('BEGIN:VCALENDAR')) {
      return BarcodeType.calendarEvent;
    }

    if (RegExp(r'^\d+$').hasMatch(rawValue) && rawValue.length >= 12) {
      return BarcodeType.product;
    }

    String cleanIsbn = rawValue.replaceAll(RegExp(r'\D'), '');
    if ((RegExp(r'^\d{13}$').hasMatch(cleanIsbn) ||
                RegExp(r'^\d{10}$').hasMatch(cleanIsbn)) &&
            cleanIsbn.length == 13 ||
        cleanIsbn.length == 10) {
      return BarcodeType.isbn;
    }

    if (rawValue.startsWith('ID')) {
      return BarcodeType.driverLicense;
    }

    return BarcodeType.text;
  }
}
