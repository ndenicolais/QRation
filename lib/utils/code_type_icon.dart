import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CodeTypeIcon {
  final IconData icon;

  CodeTypeIcon(this.icon);

  static CodeTypeIcon fromBarcodeType(BarcodeType type, String rawValue) {
    switch (type) {
      case BarcodeType.text:
        return CodeTypeIcon(MingCuteIcons.mgc_text_2_fill);
      case BarcodeType.url:
        if (rawValue.startsWith('https://www.youtube.com/') ||
            rawValue.startsWith('https://youtu.be/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_youtube_fill);
        } else if (rawValue.startsWith('https://www.facebook.com/') ||
            rawValue.startsWith('https://m.facebook.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_facebook_fill);
        } else if (rawValue.startsWith('https://www.instagram.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_instagram_fill);
        } else if (rawValue.startsWith('https://www.tiktok.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_tiktok_fill);
        } else if (rawValue.startsWith('https://t.me/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_telegram_fill);
        } else if (rawValue.startsWith('https://www.linkedin.com/') ||
            rawValue.startsWith('https://it.linkedin.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_linkedin_fill);
        } else if (rawValue.startsWith('https://x.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_social_x_fill);
        } else if (rawValue.startsWith('https://www.pinterest.com/') ||
            rawValue.startsWith('https://it.pinterest.com/')) {
          return CodeTypeIcon(MingCuteIcons.mgc_pinterest_fill);
        } else if (rawValue.startsWith('https://open.spotify.com/') ||
            rawValue.startsWith('spotify:')) {
          return CodeTypeIcon(MingCuteIcons.mgc_spotify_fill);
        } else if (rawValue.startsWith('https://wa.me/') ||
            rawValue.startsWith('whatsapp://')) {
          return CodeTypeIcon(MingCuteIcons.mgc_whatsapp_fill);
        } else {
          return CodeTypeIcon(MingCuteIcons.mgc_link_2_fill);
        }
      case BarcodeType.email:
        return CodeTypeIcon(MingCuteIcons.mgc_mail_fill);
      case BarcodeType.phone:
        return CodeTypeIcon(MingCuteIcons.mgc_phone_fill);
      case BarcodeType.sms:
        return CodeTypeIcon(MingCuteIcons.mgc_message_4_fill);
      case BarcodeType.contactInfo:
        return CodeTypeIcon(MingCuteIcons.mgc_contacts_2_fill);
      case BarcodeType.geo:
        return CodeTypeIcon(MingCuteIcons.mgc_location_2_fill);
      case BarcodeType.wifi:
        return CodeTypeIcon(MingCuteIcons.mgc_wifi_fill);
      case BarcodeType.calendarEvent:
        return CodeTypeIcon(MingCuteIcons.mgc_calendar_2_fill);
      case BarcodeType.product:
        return CodeTypeIcon(MingCuteIcons.mgc_barcode_fill);
      case BarcodeType.isbn:
        return CodeTypeIcon(MingCuteIcons.mgc_book_2_fill);
      case BarcodeType.driverLicense:
        return CodeTypeIcon(MingCuteIcons.mgc_copyright_fill);
      default:
        return CodeTypeIcon(MingCuteIcons.mgc_question_fill);
    }
  }
}
