import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/models/code_social_model.dart';

class AppConstants {
  // URI
  static final Uri uriMail = Uri(
    scheme: 'mailto',
    path: 'ndn21dev@gmail.com',
  );
  static final Uri uriGithubProfile =
      Uri.parse('https://github.com/ndenicolais');
  static final Uri uriGithubLink = Uri.parse('https://ndenicolais.github.io/');
  static final Uri uriGithubDocumentation =
      Uri.parse('https://github.com/ndenicolais');
  static final Uri uriPrivacyPolicy = Uri.parse(
      "https://www.freeprivacypolicy.com/live/d6f5528e-752e-4aba-9977-9a26b912f41f");

  // BarcodeTypes
  static final List<BarcodeType> customOrderedBarcodeTypes = [
    BarcodeType.text,
    BarcodeType.url,
    BarcodeType.email,
    BarcodeType.phone,
    BarcodeType.sms,
    BarcodeType.contactInfo,
    BarcodeType.geo,
    BarcodeType.wifi,
    BarcodeType.calendarEvent,
    BarcodeType.product,
    BarcodeType.isbn,
    BarcodeType.driverLicense,
  ];

  // Social
  static final List<CodeSocial> socialCodesList = [
    CodeSocial(
      name: 'YouTube',
      url: 'https://www.youtube.com/channel/',
      icon: MingCuteIcons.mgc_youtube_fill,
    ),
    CodeSocial(
      name: 'Facebook',
      url: 'https://www.facebook.com/',
      icon: MingCuteIcons.mgc_facebook_fill,
    ),
    CodeSocial(
      name: 'Instagram',
      url: 'https://www.instagram.com/',
      icon: MingCuteIcons.mgc_instagram_fill,
    ),
    CodeSocial(
      name: 'TikTok',
      url: 'https://www.tiktok.com/',
      icon: MingCuteIcons.mgc_tiktok_fill,
    ),
    CodeSocial(
      name: 'Telegram',
      url: 'https://telegram.org/',
      icon: MingCuteIcons.mgc_telegram_fill,
    ),
    CodeSocial(
      name: 'LinkedIn',
      url: 'https://www.linkedin.com/',
      icon: MingCuteIcons.mgc_linkedin_fill,
    ),
    CodeSocial(
      name: 'X',
      url: 'https://x.com/',
      icon: MingCuteIcons.mgc_social_x_fill,
    ),
    CodeSocial(
      name: 'Pinterest',
      url: 'https://www.pinterest.com/',
      icon: MingCuteIcons.mgc_pinterest_fill,
    ),
    CodeSocial(
      name: 'Spotify',
      url: 'https://open.spotify.com/',
      icon: MingCuteIcons.mgc_spotify_fill,
    ),
    CodeSocial(
      name: 'WhatsApp',
      url: 'https://wa.me/',
      icon: MingCuteIcons.mgc_whatsapp_fill,
    ),
  ];
}
