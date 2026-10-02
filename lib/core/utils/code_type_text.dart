// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:qration/l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CodeTypeText {
  final String type;

  CodeTypeText(this.type);

  static CodeTypeText fromBarcodeType(
    BarcodeType type,
    String rawValue,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case BarcodeType.text:
        return CodeTypeText(l10n.code_type_text_text);
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
          return CodeTypeText(l10n.code_type_text_url);
        }
      case BarcodeType.email:
        return CodeTypeText(l10n.code_type_text_email);
      case BarcodeType.phone:
        return CodeTypeText(l10n.code_type_text_phone);
      case BarcodeType.sms:
        return CodeTypeText(l10n.code_type_text_sms);
      case BarcodeType.contactInfo:
        return CodeTypeText(l10n.code_type_text_contact);
      case BarcodeType.geo:
        return CodeTypeText(l10n.code_type_text_location);
      case BarcodeType.wifi:
        return CodeTypeText(l10n.code_type_text_wifi);
      case BarcodeType.calendarEvent:
        return CodeTypeText(l10n.code_type_text_event);
      case BarcodeType.product:
        return CodeTypeText(l10n.code_type_text_product);
      case BarcodeType.isbn:
        return CodeTypeText(l10n.code_type_text_isbn);
      case BarcodeType.driverLicense:
        return CodeTypeText(l10n.code_type_text_license);
      default:
        return CodeTypeText(l10n.code_type_text_unknown);
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
