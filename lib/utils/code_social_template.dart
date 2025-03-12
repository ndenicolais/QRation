import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/models/code_social_model.dart';
import 'package:qration/utils/code_type_conversion.dart';

CodeModel createCodeSocialTemplate(String content) {
  BarcodeType barcodeType = CodeTypeConversion.detectBarcodeType(content);
  IconData icon;
  String name;
  Color qrColor;

  if (content.startsWith('https://www.youtube.com/') ||
      content.startsWith('https://youtu.be/')) {
    icon = MingCuteIcons.mgc_youtube_fill;
    name = 'YouTube';
    qrColor = Color(0xFFF61C0D);
  } else if (content.startsWith('https://www.facebook.com/') ||
      content.startsWith('https://m.facebook.com/')) {
    icon = MingCuteIcons.mgc_facebook_fill;
    name = 'Facebook';
    qrColor = Color(0xFF1976D2);
  } else if (content.startsWith('https://www.instagram.com/')) {
    icon = MingCuteIcons.mgc_instagram_fill;
    name = 'Instagram';
    qrColor = Color(0xFFD33D94);
  } else if (content.startsWith('https://www.tiktok.com/')) {
    icon = MingCuteIcons.mgc_tiktok_fill;
    name = 'TikTok';
    qrColor = Color(0xFF010101);
  } else if (content.startsWith('https://t.me/')) {
    icon = MingCuteIcons.mgc_telegram_fill;
    name = 'Telegram';
    qrColor = Color(0xFF039BE5);
  } else if (content.startsWith('https://www.linkedin.com/') ||
      content.startsWith('https://it.linkedin.com/')) {
    icon = MingCuteIcons.mgc_linkedin_fill;
    name = 'LinkedIn';
    qrColor = Color(0xFF0077B7);
  } else if (content.startsWith('https://x.com/')) {
    icon = MingCuteIcons.mgc_social_x_fill;
    name = 'X';
    qrColor = Color(0xFF000000);
  } else if (content.startsWith('https://www.pinterest.com/') ||
      content.startsWith('https://it.pinterest.com/')) {
    icon = MingCuteIcons.mgc_pinterest_fill;
    name = 'Pinterest';
    qrColor = Color(0xFFCB1F24);
  } else if (content.startsWith('https://open.spotify.com/') ||
      content.startsWith('spotify:')) {
    icon = MingCuteIcons.mgc_spotify_fill;
    name = 'Spotify';
    qrColor = Color(0xFF4CAF50);
  } else if (content.startsWith('https://wa.me/') ||
      content.startsWith('whatsapp://')) {
    icon = MingCuteIcons.mgc_whatsapp_fill;
    name = 'WhatsApp';
    qrColor = Color(0xFF4CAF50);
  } else {
    icon = MingCuteIcons.mgc_link_2_fill;
    name = 'Link';
    qrColor = Color(0xFF000000);
  }

  return CodeModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    barcode: Barcode(
      rawValue: content,
      type: barcodeType,
    ),
    date: DateTime.now(),
    source: CodeSource.scanned,
    eyeColor: qrColor,
    moduleColor: qrColor,
    socialMedia: CodeSocial(
      name: name,
      url: content,
      icon: icon,
    ),
  );
}
