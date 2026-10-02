// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/utils/validator.dart';
import 'package:qration/features/codes/controllers/qr_style_mixin.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

class GeneratedContent {
  const GeneratedContent.success(this.content) : error = null;
  const GeneratedContent.error(this.error) : content = null;

  final String? content;
  final String? error;
}

class CodeCreateStandardController extends GetxController with QrStyleMixin {
  CodeCreateStandardController({required this.type});

  final BarcodeType type;
  final CodesRepository _codesService = Get.find<CodesRepository>();

  final Map<String, TextEditingController> controllers = {};

  final selectedPrefix = '+39'.obs;
  final selectedEncryption = 'WPA/WPA2'.obs;
  final isHiddenNetwork = false.obs;
  final isLoading = false.obs;

  static const List<String> encryptionOptions = ['WPA/WPA2', 'WEP', 'None'];

  CodeModel? lastCreatedCode;
  Object? lastError;

  @override
  void onInit() {
    super.onInit();
    controllers.addAll({
      'default': TextEditingController(),
      'url': TextEditingController(),
      'emailAddress': TextEditingController(),
      'emailSubject': TextEditingController(),
      'emailBody': TextEditingController(),
      'phone': TextEditingController(),
      'smsPhone': TextEditingController(),
      'smsMessage': TextEditingController(),
      'contactName': TextEditingController(),
      'contactSurname': TextEditingController(),
      'contactPhone': TextEditingController(),
      'contactEmail': TextEditingController(),
      'geoLatitude': TextEditingController(),
      'geoLongitude': TextEditingController(),
      'wifiSsid': TextEditingController(),
      'wifiPassword': TextEditingController(),
      'eventTitle': TextEditingController(),
      'eventStartDate': TextEditingController(),
      'eventEndDate': TextEditingController(),
      'eventLocation': TextEditingController(),
      'product': TextEditingController(),
      'isbn': TextEditingController(),
    });
  }

  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  bool hasContent() => controllers.values.any((c) => c.text.isNotEmpty);

  bool isFieldEmpty(String fieldValue) => fieldValue.isEmpty;

  String? _validateEmail(String? val, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (val == null || val.isEmpty) {
      return l10n.validator_email_required;
    }
    String? emailError = val.emailValidationError(context);
    if (emailError != null) {
      return '${l10n.validator_email_error} $emailError';
    }
    return null;
  }

  GeneratedContent? _requireField(
    BuildContext context,
    String label,
    String value,
  ) {
    if (!isFieldEmpty(value)) return null;
    final l10n = AppLocalizations.of(context)!;
    return GeneratedContent.error(
      '${l10n.code_create_standard_screen_validator_field_a} $label ${l10n.code_create_standard_screen_validator_field_b}',
    );
  }

  GeneratedContent generateContent(BuildContext context) {
    switch (type) {
      case BarcodeType.url:
        return _generateUrlContent(context);
      case BarcodeType.email:
        return _generateEmailContent(context);
      case BarcodeType.phone:
        return _generatePhoneContent(context);
      case BarcodeType.sms:
        return _generateSmsContent(context);
      case BarcodeType.contactInfo:
        return _generateContactInfoContent(context);
      case BarcodeType.geo:
        return _generateGeoContent(context);
      case BarcodeType.wifi:
        return _generateWifiContent(context);
      case BarcodeType.calendarEvent:
        return _generateCalendarEventContent(context);
      case BarcodeType.product:
        return _generateProductContent(context);
      case BarcodeType.isbn:
        return _generateIsbnContent(context);
      default:
        return _generateDefaultContent(context);
    }
  }

  GeneratedContent _generateUrlContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = controllers['url']?.text.trim() ?? '';
    final emptyError = _requireField(
        context, l10n.code_create_standard_screen_url_label, content);
    if (emptyError != null) {
      return GeneratedContent.error(
          l10n.code_create_standard_screen_validator_url);
    }
    if (!(content.startsWith('www') || content.startsWith('http'))) {
      return GeneratedContent.error(
          l10n.code_create_standard_screen_error_url_length);
    }
    if (content.length <= 7) {
      return GeneratedContent.error(
          l10n.code_create_standard_screen_validator_url);
    }
    return GeneratedContent.success(content);
  }

  GeneratedContent _generateEmailContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emailAddress = controllers['emailAddress']?.text.trim() ?? '';
    final emailSubject = controllers['emailSubject']?.text.trim() ?? '';
    final emailBody = controllers['emailBody']?.text.trim() ?? '';

    final addressError = _requireField(context,
        l10n.code_create_standard_screen_email_address_label, emailAddress);
    if (addressError != null) return addressError;
    final subjectError = _requireField(context,
        l10n.code_create_standard_screen_email_subject_label, emailSubject);
    if (subjectError != null) return subjectError;
    final bodyError = _requireField(
        context, l10n.code_create_standard_screen_email_body_label, emailBody);
    if (bodyError != null) return bodyError;

    final emailValidationError = _validateEmail(emailAddress, context);
    if (emailValidationError != null) {
      return GeneratedContent.error(emailValidationError);
    }

    return GeneratedContent.success(
        'MATMSG:TO:$emailAddress;SUB:$emailSubject;BODY:$emailBody;;');
  }

  GeneratedContent _generatePhoneContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = controllers['phone']?.text.trim() ?? '';
    final emptyError = _requireField(
        context, l10n.code_create_standard_screen_phone_label, content);
    if (emptyError != null) return emptyError;
    return GeneratedContent.success('tel:${selectedPrefix.value}$content');
  }

  GeneratedContent _generateSmsContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final smsPhone = controllers['smsPhone']?.text.trim() ?? '';
    final smsMessage = controllers['smsMessage']?.text.trim() ?? '';

    final phoneError = _requireField(
        context, l10n.code_create_standard_screen_sms_phone_label, smsPhone);
    if (phoneError != null) return phoneError;
    final messageError = _requireField(context,
        l10n.code_create_standard_screen_sms_message_label, smsMessage);
    if (messageError != null) return messageError;

    return GeneratedContent.success(
        'SMSTO:${selectedPrefix.value}$smsPhone:$smsMessage');
  }

  GeneratedContent _generateContactInfoContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contactName = controllers['contactName']?.text.trim() ?? '';
    final contactSurname = controllers['contactSurname']?.text.trim() ?? '';
    final contactPhone = controllers['contactPhone']?.text.trim() ?? '';
    final contactEmail = controllers['contactEmail']?.text.trim() ?? '';

    final nameError = _requireField(context,
        l10n.code_create_standard_screen_contact_name_label, contactName);
    if (nameError != null) return nameError;
    final surnameError = _requireField(context,
        l10n.code_create_standard_screen_contact_surname_label, contactSurname);
    if (surnameError != null) return surnameError;
    final phoneError = _requireField(context,
        l10n.code_create_standard_screen_contact_phone_label, contactPhone);
    if (phoneError != null) return phoneError;
    final emailError = _requireField(context,
        l10n.code_create_standard_screen_contact_email_label, contactEmail);
    if (emailError != null) return emailError;

    final emailValidationError = _validateEmail(contactEmail, context);
    if (emailValidationError != null) {
      return GeneratedContent.error(emailValidationError);
    }

    return GeneratedContent.success('''BEGIN:VCARD
VERSION:2.1
FN:$contactName $contactSurname
N:$contactSurname;$contactName
TEL:${selectedPrefix.value}$contactPhone
EMAIL:$contactEmail
END:VCARD''');
  }

  GeneratedContent _generateGeoContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final geoLatitude = controllers['geoLatitude']?.text.trim() ?? '';
    final geoLongitude = controllers['geoLongitude']?.text.trim() ?? '';

    final latError = _requireField(context,
        l10n.code_create_standard_screen_geo_latitude_label, geoLatitude);
    if (latError != null) return latError;
    final lonError = _requireField(context,
        l10n.code_create_standard_screen_geo_longitude_label, geoLongitude);
    if (lonError != null) return lonError;

    return GeneratedContent.success('geo:$geoLatitude,$geoLongitude');
  }

  GeneratedContent _generateWifiContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wifiSsid = controllers['wifiSsid']?.text.trim() ?? '';
    final wifiPassword = controllers['wifiPassword']?.text.trim() ?? '';

    final ssidError = _requireField(
        context, l10n.code_create_standard_screen_wifi_ssid_label, wifiSsid);
    if (ssidError != null) return ssidError;
    final passwordError = _requireField(context,
        l10n.code_create_standard_screen_wifi_password_label, wifiPassword);
    if (passwordError != null) return passwordError;

    final encryption = selectedEncryption.value;
    final hidden = isHiddenNetwork.value.toString();
    return GeneratedContent.success(encryption == 'WPA/WPA2'
        ? 'WIFI:T:WPA;S:$wifiSsid;P:$wifiPassword;H:$hidden;'
        : 'WIFI:T:$encryption;S:$wifiSsid;P:$wifiPassword;H:$hidden;');
  }

  GeneratedContent _generateCalendarEventContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eventTitle = controllers['eventTitle']?.text.trim() ?? '';
    var eventStartDate = controllers['eventStartDate']?.text.trim() ?? '';
    var eventEndDate = controllers['eventEndDate']?.text.trim() ?? '';
    final eventLocation = controllers['eventLocation']?.text.trim() ?? '';

    final titleError = _requireField(context,
        l10n.code_create_standard_screen_calendar_title_label, eventTitle);
    if (titleError != null) return titleError;
    final startError = _requireField(
        context,
        l10n.code_create_standard_screen_calendar_start_date_label,
        eventStartDate);
    if (startError != null) return startError;
    final endError = _requireField(context,
        l10n.code_create_standard_screen_calendar_end_date_label, eventEndDate);
    if (endError != null) return endError;

    String formatDateTime(String date) {
      final dateTime = DateTime.parse(date);
      return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0]}Z';
    }

    eventStartDate = formatDateTime(eventStartDate);
    eventEndDate = formatDateTime(eventEndDate);

    return GeneratedContent.success('BEGIN:VCALENDAR\r\n'
        'VERSION:2.0\r\n'
        'BEGIN:VEVENT\r\n'
        'DTSTART:$eventStartDate\r\n'
        'DTEND:$eventEndDate\r\n'
        'SUMMARY:$eventTitle\r\n'
        'LOCATION:$eventLocation\r\n'
        'END:VEVENT\r\n'
        'END:VCALENDAR');
  }

  GeneratedContent _generateProductContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product = controllers['product']?.text.trim() ?? '';
    final emptyError = _requireField(
        context, l10n.code_create_standard_screen_product_label, product);
    if (emptyError != null) return emptyError;
    return GeneratedContent.success(product);
  }

  GeneratedContent _generateIsbnContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isbn = controllers['isbn']?.text.trim() ?? '';
    final emptyError = _requireField(
        context, l10n.code_create_standard_screen_isbn_label, isbn);
    if (emptyError != null) return emptyError;
    return GeneratedContent.success(isbn);
  }

  GeneratedContent _generateDefaultContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = controllers['default']?.text.trim() ?? '';
    final emptyError = _requireField(
        context, l10n.code_create_standard_screen_text_label, content);
    if (emptyError != null) return emptyError;
    return GeneratedContent.success(content);
  }

  Future<bool> createQrCode(String content) async {
    isLoading.value = true;
    final barcode = Barcode(rawValue: content, type: type);
    final code = CodeModel(
      id: '',
      barcode: barcode,
      date: DateTime.now(),
      source: CodeSource.created,
      eyeColor: eyeColor.value,
      eyeRounded: eyeRounded.value,
      moduleColor: moduleColor.value,
      moduleRounded: moduleRounded.value,
      logoPath: logoPath.value,
    );

    try {
      await _codesService.addCode(code);
      lastCreatedCode = code;
      return true;
    } catch (e) {
      lastError = e;
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
