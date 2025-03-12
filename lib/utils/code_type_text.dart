import 'package:mobile_scanner/mobile_scanner.dart';

class CodeTypeText {
  final String type;

  CodeTypeText(this.type);

  static CodeTypeText fromBarcodeType(BarcodeType type, String rawValue) {
    switch (type) {
      case BarcodeType.text:
        return CodeTypeText('Text');
      case BarcodeType.url:
        if (rawValue.startsWith('https://www.youtube.com/') ||
            rawValue.startsWith('https://youtu.be/')) {
          return CodeTypeText('YouTube');
        } else if (rawValue.startsWith('https://www.facebook.com/') ||
            rawValue.startsWith('https://m.facebook.com/')) {
          return CodeTypeText('Facebook');
        } else if (rawValue.startsWith('https://www.instagram.com/')) {
          return CodeTypeText('Instagram');
        } else if (rawValue.startsWith('https://www.tiktok.com/')) {
          return CodeTypeText('TikTok');
        } else if (rawValue.startsWith('https://t.me/')) {
          return CodeTypeText('Telegram');
        } else if (rawValue.startsWith('https://www.linkedin.com/') ||
            rawValue.startsWith('https://it.linkedin.com/')) {
          return CodeTypeText('LinkedIn');
        } else if (rawValue.startsWith('https://x.com/')) {
          return CodeTypeText('X');
        } else if (rawValue.startsWith('https://www.pinterest.com/') ||
            rawValue.startsWith('https://it.pinterest.com/')) {
          return CodeTypeText('Pinterest');
        } else if (rawValue.startsWith('https://open.spotify.com/') ||
            rawValue.startsWith('spotify:')) {
          return CodeTypeText('Spotify');
        } else if (rawValue.startsWith('https://wa.me/') ||
            rawValue.startsWith('whatsapp://')) {
          return CodeTypeText('WhatsApp');
        } else {
          return CodeTypeText('URL');
        }
      case BarcodeType.email:
        return CodeTypeText('Email');
      case BarcodeType.phone:
        return CodeTypeText('Phone');
      case BarcodeType.sms:
        return CodeTypeText('SMS');
      case BarcodeType.contactInfo:
        return CodeTypeText('Contact');
      case BarcodeType.geo:
        return CodeTypeText('Location');
      case BarcodeType.wifi:
        return CodeTypeText('WiFi');
      case BarcodeType.calendarEvent:
        return CodeTypeText('Event');
      case BarcodeType.product:
        return CodeTypeText('Product');
      case BarcodeType.isbn:
        return CodeTypeText('ISBN');
      case BarcodeType.driverLicense:
        return CodeTypeText('License');
      default:
        return CodeTypeText('Unknown');
    }
  }
}

BarcodeType fromStringToBarcodeType(String typeString) {
  switch (typeString) {
    case 'text':
      return BarcodeType.text;
    case 'url':
      return BarcodeType.url;
    case 'email':
      return BarcodeType.email;
    case 'phone':
      return BarcodeType.phone;
    case 'sms':
      return BarcodeType.sms;
    case 'contactInfo':
      return BarcodeType.contactInfo;
    case 'geo':
      return BarcodeType.geo;
    case 'wifi':
      return BarcodeType.wifi;
    case 'calendarEvent':
      return BarcodeType.calendarEvent;
    case 'product':
      return BarcodeType.product;
    case 'isbn':
      return BarcodeType.isbn;
    case 'driverLicense':
      return BarcodeType.driverLicense;
    default:
      return BarcodeType.unknown;
  }
}
