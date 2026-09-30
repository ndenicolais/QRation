// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:qration/core/utils/code_type_icon.dart';
import 'package:qration/core/utils/permission_helper.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_types.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wifi_iot/wifi_iot.dart';

enum SaveQrResult { success, emptyImage, error }

class SearchOption {
  final String label;
  final IconData icon;
  final String url;

  const SearchOption({
    required this.label,
    required this.icon,
    required this.url,
  });
}

class CodeDetailsController extends GetxController {
  CodeDetailsController(this.code)
      : contentIcon = CodeTypeIcon.fromBarcodeType(
          code.barcode.type,
          code.barcode.rawValue ?? '',
        );

  final CodeModel code;
  final CodeTypeIcon contentIcon;
  final CodesRepository _codesService = Get.find<CodesRepository>();
  final Logger logger = Logger();
  final ScreenshotController screenshotController = ScreenshotController();

  final isExpanded = false.obs;
  final isFavorite = false.obs;
  final isCodeDeleted = false.obs;
  final notes = RxnString();

  @override
  void onInit() {
    super.onInit();
    isFavorite.value = code.isFavorite;
    notes.value = code.notes;
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  Future<void> toggleFavorite() async {
    isFavorite.value = !isFavorite.value;
    code.isFavorite = isFavorite.value;
    await _codesService.toggleFavoriteStatus(code.id, code.isFavorite);
  }

  Future<SaveQrResult> saveQRCode() async {
    try {
      final image = await screenshotController.capture();
      if (image == null) return SaveQrResult.emptyImage;

      final Uint8List pngBytes = image;
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        name: 'qration_$timestamp',
        quality: 100,
      );

      return result['isSuccess'] == true
          ? SaveQrResult.success
          : SaveQrResult.error;
    } catch (e) {
      return SaveQrResult.error;
    }
  }

  void copyToClipboard(String content) {
    Clipboard.setData(ClipboardData(text: content));
  }

  Future<void> updateNotes(String value) async {
    await _codesService.updateCodeNotes(code.id, value);
    code.notes = value;
    notes.value = value;
  }

  Future<void> deleteCode() async {
    await _codesService.deleteCode(code.id);
    isCodeDeleted.value = true;
  }

  Future<bool> launchURL(String url) async {
    Uri uri;

    if (url.startsWith('spotify:search:')) {
      uri = Uri.parse('https://open.spotify.com/${url.substring(8)}');
    } else if (url.startsWith('whatsapp:') || url.startsWith('spotify:')) {
      uri = Uri.parse(url);
    } else {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'http://$url';
      }
      uri = Uri.parse(url);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  Future<void> sendEmail(String email, String? subject, String? body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: (subject != null
              ? 'subject=${Uri.encodeComponent(subject)}'
              : '') +
          (body != null
              ? '${subject != null ? '&' : ''}body=${Uri.encodeComponent(body)}'
              : ''),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Could not launch $emailUri');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> sendSms(String phoneNumber, String? message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw ('Could not launch SMS: $smsUri');
    }
  }

  Future<bool> addContact(
    BuildContext context,
    String name,
    String surname,
    String phoneNumber,
    String email,
  ) async {
    try {
      await requestContactsPermission(context);
      final contact = contacts.Contact()
        ..name.first = name
        ..name.last = surname
        ..phones = [contacts.Phone(phoneNumber)];

      if (email.isNotEmpty) {
        contact.emails = [contacts.Email(email)];
      }

      try {
        await contacts.FlutterContacts.insertContact(contact);
        return true;
      } catch (e) {
        logger.e('Error while adding contact: $e');
        return false;
      }
    } catch (e) {
      logger.e('Error while requesting permissions: $e');
      return false;
    }
  }

  Future<void> openMap(String latitude, String longitude) async {
    final String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> connectToWifi(String ssid, String password) async {
    logger.i('Trying to connect to WiFi');
    logger.i('SSID: $ssid, Password: $password');

    try {
      bool result = await WiFiForIoTPlugin.findAndConnect(
        ssid,
        password: password,
        joinOnce: false,
        withInternet: true,
      );

      if (result) {
        logger.i('Connected to $ssid');
      } else {
        logger.e('Error connecting to $ssid: Connection failed.');
      }
      return true;
    } catch (e) {
      logger.e('Error connecting to WiFi: $e');
      return false;
    }
  }

  void addEventToCalendar(String rawValue) {
    String title = '';
    String startDate = '';
    String endDate = '';
    String location = '';
    List<String> lines = rawValue.split('\n');
    for (String line in lines) {
      if (line.startsWith('SUMMARY:')) {
        title = line.replaceFirst('SUMMARY:', '').trim();
      } else if (line.startsWith('DTSTART:')) {
        String datetime = line.replaceFirst('DTSTART:', '').trim();
        startDate = convertToCustomFormat(datetime);
      } else if (line.startsWith('DTEND:')) {
        String datetime = line.replaceFirst('DTEND:', '').trim();
        endDate = convertToCustomFormat(datetime);
      } else if (line.startsWith('LOCATION:')) {
        location = line.replaceFirst('LOCATION:', '').trim();
      }
    }

    if (title.isNotEmpty && startDate.isNotEmpty) {
      DateTime eventStartDateTime = DateTime.parse(startDate);
      DateTime eventEndDateTime;

      if (endDate.isNotEmpty) {
        eventEndDateTime = DateTime.parse(endDate);
      } else {
        eventEndDateTime = eventStartDateTime.add(Duration(hours: 1));
      }

      Event event = Event(
        title: title,
        description: '',
        location: location,
        startDate: eventStartDateTime,
        endDate: eventEndDateTime,
        androidParams: AndroidParams(emailInvites: ['example@example.com']),
      );
      Add2Calendar.addEvent2Cal(event);
    }
  }

  List<SearchOption> searchProductOptions(
    String barcode, {
    required String amazonLabel,
    required String ebayLabel,
    required String googleLabel,
  }) {
    return [
      SearchOption(
        label: amazonLabel,
        icon: LineAwesomeIcons.amazon,
        url: 'https://www.amazon.com/s?k=$barcode',
      ),
      SearchOption(
        label: ebayLabel,
        icon: LineAwesomeIcons.ebay,
        url: 'https://www.ebay.com/sch/i.html?_nkw=$barcode',
      ),
      SearchOption(
        label: googleLabel,
        icon: LineAwesomeIcons.google,
        url: 'https://www.google.com/search?q=$barcode',
      ),
    ];
  }

  List<SearchOption> searchBookOptions(
    String isbn, {
    required String googleBooksLabel,
    required String amazonLabel,
    required String goodreadsLabel,
  }) {
    return [
      SearchOption(
        label: googleBooksLabel,
        icon: LineAwesomeIcons.book_solid,
        url: 'https://books.google.com/books?vid=ISBN$isbn',
      ),
      SearchOption(
        label: amazonLabel,
        icon: LineAwesomeIcons.amazon,
        url: 'https://www.amazon.com/s?k=$isbn',
      ),
      SearchOption(
        label: goodreadsLabel,
        icon: LineAwesomeIcons.goodreads,
        url: 'https://www.goodreads.com/search?q=$isbn',
      ),
    ];
  }

  Future<bool> openSearchOption(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
      return true;
    }
    logger.e('Cannot open $url');
    return false;
  }
}
