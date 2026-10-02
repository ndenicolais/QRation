// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:qration/core/theme/app_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_font_sizes.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_types.dart';
import 'package:qration/core/widgets/section_card.dart';

class CodeContentCard extends StatelessWidget {
  const CodeContentCard({
    super.key,
    required this.title,
    required this.code,
    required this.controller,
  });

  final String title;
  final CodeModel code;
  final CodeDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: MingCuteIcons.mgc_document_2_fill,
      child: _buildContentWidget(context),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    final barcode = code.barcode;
    final l10n = AppLocalizations.of(context)!;

    switch (barcode.type) {
      case BarcodeType.text:
        return Obx(() => _buildCard(
              context: context,
              content: Text(
                barcode.rawValue ?? '',
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: controller.isExpanded.value ? null : 3,
                overflow: controller.isExpanded.value
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              buttonText: l10n.code_details_screen_action_text,
              buttonIcon: MingCuteIcons.mgc_copy_2_line,
              onButtonPressed: () =>
                  _copyToClipboard(context, barcode.rawValue ?? ''),
            ));

      case BarcodeType.url:
        return Obx(() => _buildCard(
              context: context,
              content: Text(
                CodeUrl.fromRawValue(barcode.rawValue ?? '').displayValue,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: controller.isExpanded.value ? null : 3,
                overflow: controller.isExpanded.value
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              buttonText: l10n.code_details_screen_action_url,
              buttonIcon: MingCuteIcons.mgc_external_link_line,
              onButtonPressed: () =>
                  _launchURL(context, barcode.rawValue ?? ''),
            ));

      case BarcodeType.email:
        CodeEmail email = CodeEmail.fromRawValue(barcode.rawValue ?? '');
        return Obx(() => _buildCard(
              context: context,
              content: Column(
                children: [
                  Text(
                    email.address,
                    style: AppFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.normal,
                    ),
                  ),
                  if (email.subject != null && email.subject!.isNotEmpty)
                    Text(
                      email.subject!,
                      style: AppFonts.montserrat(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.normal,
                      ),
                    ),
                  if (email.body != null && email.body!.isNotEmpty)
                    Text(
                      email.body!,
                      style: AppFonts.montserrat(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppFontSizes.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: controller.isExpanded.value ? null : 3,
                      overflow: controller.isExpanded.value
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                ],
              ),
              buttonText: l10n.code_details_screen_action_email,
              buttonIcon: MingCuteIcons.mgc_mail_send_line,
              onButtonPressed: () =>
                  _sendEmail(context, email.address, email.subject, email.body),
            ));

      case BarcodeType.phone:
        CodePhoneNumber phoneNumber =
            CodePhoneNumber.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Text(
            phoneNumber.number,
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppFontSizes.normal,
            ),
          ),
          buttonText: l10n.code_details_screen_action_phone,
          buttonIcon: MingCuteIcons.mgc_phone_call_line,
          onButtonPressed: () => _makePhoneCall(context, phoneNumber.number),
        );

      case BarcodeType.sms:
        CodeSms sms = CodeSms.fromRawValue(barcode.rawValue ?? '');
        return Obx(() => _buildCard(
              context: context,
              content: Column(
                children: [
                  Text(
                    sms.phoneNumber,
                    style: AppFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.normal,
                    ),
                  ),
                  Text(
                    sms.message,
                    style: AppFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFontSizes.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: controller.isExpanded.value ? null : 3,
                    overflow: controller.isExpanded.value
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                ],
              ),
              buttonText: l10n.code_details_screen_action_sms,
              buttonIcon: MingCuteIcons.mgc_chat_1_line,
              onButtonPressed: () =>
                  _sendSms(context, sms.phoneNumber, sms.message),
            ));

      case BarcodeType.contactInfo:
        CodeContact contact = CodeContact.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Column(
            children: [
              Text(
                '${contact.name} ${contact.surname}',
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
              if (contact.phoneNumber.isNotEmpty)
                Text(
                  contact.phoneNumber,
                  style: AppFonts.montserrat(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppFontSizes.normal,
                  ),
                ),
              if (contact.email.isNotEmpty)
                Text(
                  contact.email,
                  style: AppFonts.montserrat(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppFontSizes.normal,
                  ),
                ),
            ],
          ),
          buttonText: l10n.code_details_screen_action_contact,
          buttonIcon: MingCuteIcons.mgc_user_add_2_line,
          onButtonPressed: () => _addContact(context, contact.name,
              contact.surname, contact.phoneNumber, contact.email),
        );

      case BarcodeType.geo:
        CodeGeo geoInfo = CodeGeo.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Column(
            children: [
              Text(
                geoInfo.latitude.toString(),
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
              Text(
                geoInfo.longitude.toString(),
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
            ],
          ),
          buttonText: l10n.code_details_screen_action_geo,
          buttonIcon: MingCuteIcons.mgc_map_line,
          onButtonPressed: () =>
              _openMap(context, geoInfo.latitude, geoInfo.longitude),
        );

      case BarcodeType.wifi:
        CodeWifi wifiInfo = CodeWifi.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Column(
            children: [
              Text(
                wifiInfo.ssid,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
              Text(
                wifiInfo.password,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
              Text(
                wifiInfo.authenticationType,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
              Text(
                wifiInfo.hidden.toString(),
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
            ],
          ),
          buttonText: l10n.code_details_screen_action_wifi,
          buttonIcon: MingCuteIcons.mgc_wifi_line,
          onButtonPressed: () =>
              _connectToWifi(context, wifiInfo.ssid, wifiInfo.password),
        );

      case BarcodeType.calendarEvent:
        CodeEvent eventInfo = CodeEvent.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Text(
            eventInfo.toString(),
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppFontSizes.normal,
            ),
          ),
          buttonText: l10n.code_details_screen_action_calendar,
          buttonIcon: MingCuteIcons.mgc_calendar_add_line,
          onButtonPressed: () =>
              controller.addEventToCalendar(eventInfo.toRawValue()),
        );

      case BarcodeType.product:
        CodeProduct productInfo =
            CodeProduct.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Column(
            children: [
              Text(
                l10n.code_details_screen_product,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                productInfo.toString(),
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
            ],
          ),
          buttonText: l10n.code_details_screen_action_product,
          buttonIcon: MingCuteIcons.mgc_list_search_line,
          onButtonPressed: () =>
              _searchProductOnline(context, productInfo.barcode),
        );

      case BarcodeType.isbn:
        CodeISBN isbnInfo = CodeISBN.fromRawValue(barcode.rawValue ?? '');
        return _buildCard(
          context: context,
          content: Column(
            children: [
              Text(
                l10n.code_details_screen_isbn,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isbnInfo.toString(),
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppFontSizes.normal,
                ),
              ),
            ],
          ),
          buttonText: l10n.code_details_screen_action_isbn,
          buttonIcon: MingCuteIcons.mgc_book_2_line,
          onButtonPressed: () => _searchBookOnline(context, isbnInfo.isbn),
        );

      default:
        return SelectableText(
          barcode.rawValue ?? '',
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppFontSizes.regular,
          ),
        );
    }
  }

  Widget _buildCard({
    required BuildContext context,
    required Widget content,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onButtonPressed,
  }) {
    return Column(
      children: [
        content,
        if ((code.barcode.rawValue?.length ?? 0) > 200)
          Obx(() => IconButton(
                onPressed: controller.toggleExpanded,
                icon: Icon(
                  controller.isExpanded.value
                      ? MingCuteIcons.mgc_arrows_up_line
                      : MingCuteIcons.mgc_arrows_down_line,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              )),
        SizedBox(height: 14),
        ElevatedButton.icon(
          onPressed: onButtonPressed,
          icon: Icon(buttonIcon, size: 22),
          label: Text(buttonText),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String content) {
    controller.copyToClipboard(content);
    if (context.mounted) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.code_details_screen_result_copy,
      );
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final success = await controller.launchURL(url);
    if (!success && context.mounted) {
      showErrorToast(context,
          AppLocalizations.of(context)!.code_details_screen_toast_error_link);
    }
  }

  Future<void> _sendEmail(
      BuildContext context, String email, String? subject, String? body) async {
    try {
      await controller.sendEmail(email, subject, body);
    } catch (e) {
      // Same as before the refactor: errors are not surfaced to the user here.
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    await controller.makePhoneCall(phoneNumber);
  }

  Future<void> _sendSms(
      BuildContext context, String phoneNumber, String? message) async {
    await controller.sendSms(phoneNumber, message);
  }

  Future<void> _addContact(BuildContext context, String name, String surname,
      String phoneNumber, String email) async {
    final success =
        await controller.addContact(context, name, surname, phoneNumber, email);
    if (success && context.mounted) {
      showSuccessToast(context,
          AppLocalizations.of(context)!.code_details_screen_result_contact);
    }
  }

  Future<void> _openMap(
      BuildContext context, String latitude, String longitude) async {
    await controller.openMap(latitude, longitude);
  }

  Future<void> _connectToWifi(
      BuildContext context, String ssid, String password) async {
    final success = await controller.connectToWifi(ssid, password);
    if (success && context.mounted) {
      showSuccessToast(context,
          AppLocalizations.of(context)!.code_details_screen_result_wifi);
    }
  }

  Future<void> _searchProductOnline(
      BuildContext context, String barcode) async {
    final l10n = AppLocalizations.of(context)!;
    final options = controller.searchProductOptions(
      barcode,
      amazonLabel: l10n.code_details_screen_result_product_amazon,
      ebayLabel: l10n.code_details_screen_result_product_ebay,
      googleLabel: l10n.code_details_screen_result_product_google,
    );
    _showSearchBottomSheet(context, options);
  }

  Future<void> _searchBookOnline(BuildContext context, String isbn) async {
    final l10n = AppLocalizations.of(context)!;
    final options = controller.searchBookOptions(
      isbn,
      googleBooksLabel: l10n.code_details_screen_result_isbn_google_books,
      amazonLabel: l10n.code_details_screen_result_isbn_amazon,
      goodreadsLabel: l10n.code_details_screen_result_isbn_goodreads,
    );
    _showSearchBottomSheet(context, options);
  }

  void _showSearchBottomSheet(
      BuildContext context, List<SearchOption> options) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((option) => _buildSearchOption(context, option))
              .toList(),
        );
      },
    );
  }

  ListTile _buildSearchOption(BuildContext context, SearchOption option) {
    return ListTile(
      leading: Icon(
        option.icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        option.label,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
      ),
      onTap: () async {
        await controller.openSearchOption(option.url);
        if (context.mounted) {
          Get.back();
        }
      },
    );
  }
}
