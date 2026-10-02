// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/utils/code_type_text.dart';
import 'package:qration/core/utils/isbn_formatter.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/codes/widgets/code_create/code_create_app_bar.dart';
import 'package:qration/features/codes/widgets/code_create/discard_dialog.dart';
import 'package:qration/features/codes/widgets/code_create/generate_button.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/core/widgets/app_button.dart';
import 'package:qration/features/codes/widgets/code_create/qr_preview.dart';
import 'package:qration/features/codes/widgets/code_create/qr_style_customizer.dart';
import 'package:qration/features/codes/widgets/code_create/custom_picker_field.dart';
import 'package:qration/features/codes/widgets/code_create/full_screen_map.dart';

class CodeCreateStandardScreen extends StatefulWidget {
  final BarcodeType type;

  const CodeCreateStandardScreen({super.key, required this.type});

  @override
  CodeCreateStandardScreenState createState() =>
      CodeCreateStandardScreenState();
}

class CodeCreateStandardScreenState extends State<CodeCreateStandardScreen> {
  late final CodeCreateStandardController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CodeTypeText _contentType;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CodeCreateStandardController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contentType = CodeTypeText.fromBarcodeType(
      widget.type,
      '',
      AppLocalizations.of(context)!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!_controller.hasContent()) {
          Get.back();
          return;
        }
        final shouldPop = await showDiscardDialog(context);
        if (shouldPop && context.mounted) Get.back();
      },
      child: Scaffold(
        appBar: CodeCreateAppBar(
          title: _contentType.type,
          hasContent: _controller.hasContent,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.h,
              children: [
                SectionCard(
                  title: AppLocalizations.of(context)!
                      .code_details_screen_content_title,
                  icon: MingCuteIcons.mgc_edit_2_fill,
                  child: _buildInputFields(context),
                ),
                QrPreview(
                  style: _controller,
                  contentListenable:
                      Listenable.merge(_controller.controllers.values.toList()),
                  data: _previewContent,
                ),
                QrStyleCustomizer(style: _controller),
                Obx(
                  () => GenerateButton(
                    isLoading: _controller.isLoading.value,
                    label: AppLocalizations.of(context)!
                        .code_create_standard_screen_create_button,
                    onPressed: () async {
                      final result = _controller.generateContent(context);
                      if (result.content == null) {
                        if (result.error != null) {
                          showErrorToast(context, result.error!);
                        }
                        return;
                      }
                      await _createQrCode(result.content!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Content for the live preview: empty while the form is incomplete.
  String _previewContent() {
    try {
      return _controller.generateContent(context).content ?? '';
    } catch (_) {
      // e.g. a partially typed date that DateTime.parse can't read yet.
      return '';
    }
  }

  void _showLocationPicker() async {
    await Get.to(
      () => FullScreenMap(
        onLocationPicked: (LatLng location) {
          setState(() {
            _controller.controllers['geoLatitude']?.text =
                location.latitude.toString();
            _controller.controllers['geoLongitude']?.text =
                location.longitude.toString();
          });
        },
      ),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _createQrCode(String content) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _controller.controllers['default']?.text = content;
    });

    final success = await _controller.createQrCode(content);
    if (!mounted) return;

    if (success) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.code_create_standard_screen_toast_success,
      );
      Get.offNamed(AppRoutes.codeDetails,
          arguments: _controller.lastCreatedCode);
    } else {
      showErrorToast(
        context,
        '${AppLocalizations.of(context)!.code_create_standard_screen_toast_error} ${_controller.lastError}',
      );
    }
  }

  Widget _buildInputFields(BuildContext context) {
    final inputFields = {
      BarcodeType.text: _buildTextField(
        label: AppLocalizations.of(context)!
            .code_create_standard_screen_text_label,
        controllerKey: 'default',
      ),
      BarcodeType.url: _buildTextField(
        label:
            AppLocalizations.of(context)!.code_create_standard_screen_url_label,
        controllerKey: 'url',
        isUrlField: true,
      ),
      BarcodeType.email: Column(
        spacing: 12.h,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_email_address_label,
            controllerKey: 'emailAddress',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_email_subject_label,
            controllerKey: 'emailSubject',
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_email_body_label,
            controllerKey: 'emailBody',
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      BarcodeType.phone: _buildPhoneNumberField(
        label: AppLocalizations.of(context)!
            .code_create_standard_screen_phone_label,
        controllerKey: 'phone',
      ),
      BarcodeType.sms: Column(
        spacing: 12.h,
        children: [
          _buildPhoneNumberField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_sms_phone_label,
            controllerKey: 'smsPhone',
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_sms_message_label,
            controllerKey: 'smsMessage',
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      BarcodeType.contactInfo: Column(
        spacing: 12.h,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_contact_name_label,
            controllerKey: 'contactName',
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_contact_surname_label,
            controllerKey: 'contactSurname',
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          _buildPhoneNumberField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_contact_phone_label,
            controllerKey: 'contactPhone',
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_contact_email_label,
            controllerKey: 'contactEmail',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      BarcodeType.geo: Column(
        spacing: 12.h,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_geo_latitude_label,
            controllerKey: 'geoLatitude',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_geo_longitude_label,
            controllerKey: 'geoLongitude',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 10.h),
          AppButton.outlined(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_geo_select_button,
            icon: MingCuteIcons.mgc_location_fill,
            onPressed: _showLocationPicker,
          ),
        ],
      ),
      BarcodeType.wifi: Column(
        spacing: 12.h,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_wifi_ssid_label,
            controllerKey: 'wifiSsid',
            textInputAction: TextInputAction.next,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_wifi_password_label,
            controllerKey: 'wifiPassword',
            textInputAction: TextInputAction.done,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .code_create_standard_screen_wifi_type_label,
                    style: AppFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Obx(
                    () => DropdownButton<String>(
                      value: _controller.selectedEncryption.value,
                      items: CodeCreateStandardController.encryptionOptions
                          .map((String encryption) {
                        return DropdownMenuItem<String>(
                          value: encryption,
                          child: Text(
                            encryption,
                            style: AppFonts.montserrat(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _controller.selectedEncryption.value = newValue!;
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .code_create_standard_screen_wifi_hidden_label,
                    style: AppFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Obx(
                    () => Checkbox(
                      value: _controller.isHiddenNetwork.value,
                      onChanged: (bool? newValue) {
                        _controller.isHiddenNetwork.value = newValue!;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      BarcodeType.calendarEvent: Column(
        spacing: 12.h,
        children: [
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_calendar_title_label,
            controllerKey: 'eventTitle',
            textInputAction: TextInputAction.next,
          ),
          CustomPickerField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_calendar_start_date_label,
            controller: _controller.controllers['eventStartDate']!,
            isDatePicker: true,
          ),
          CustomPickerField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_calendar_end_date_label,
            controller: _controller.controllers['eventEndDate']!,
            isDatePicker: true,
          ),
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_calendar_location_label,
            controllerKey: 'eventLocation',
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      BarcodeType.product: _buildTextField(
        label: AppLocalizations.of(context)!
            .code_create_standard_screen_product_label,
        controllerKey: 'product',
        keyboardType: TextInputType.phone,
      ),
      BarcodeType.isbn: _buildTextField(
        label: AppLocalizations.of(context)!
            .code_create_standard_screen_isbn_label,
        controllerKey: 'isbn',
        keyboardType: TextInputType.number,
        isISBNField: true,
      ),
    };

    return Form(
      key: _formKey,
      child: inputFields[widget.type] ??
          _buildTextField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_text_label,
            controllerKey: 'default',
          ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String controllerKey,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.done,
    List<TextInputFormatter>? inputFormatters,
    String? initialText,
    bool isUrlField = false,
    bool isISBNField = false,
  }) {
    final controller = _controller.controllers
        .putIfAbsent(controllerKey, () => TextEditingController());

    if (initialText != null && controller.text.isEmpty) {
      controller.text = initialText;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }

    final isbnFormatters = isISBNField
        ? [
            LengthLimitingTextInputFormatter(16),
            FilteringTextInputFormatter.digitsOnly,
            ISBNFormatter(),
          ]
        : inputFormatters;

    return TextFormField(
      controller: controller,
      keyboardType: isUrlField ? TextInputType.url : keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(labelText: label),
      style: AppFonts.montserrat(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      inputFormatters: isbnFormatters,
      onChanged: isISBNField ? (value) => setState(() {}) : null,
    );
  }

  Widget _buildPhoneNumberField({
    required String label,
    required String controllerKey,
    TextInputType keyboardType = TextInputType.phone,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    final controller = _controller.controllers
        .putIfAbsent(controllerKey, () => TextEditingController());

    return Row(
      children: [
        CountryCodePicker(
          onChanged: (countryCode) {
            _controller.selectedPrefix.value = countryCode.dialCode!;
          },
          initialSelection: 'IT',
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          textStyle: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(labelText: label),
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!
                    .code_create_standard_screen_validator_number;
              }
              final regex = RegExp(r'^\d+$');
              if (!regex.hasMatch(value) || value.length < 7) {
                return AppLocalizations.of(context)!
                    .code_create_standard_screen_validator_number;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
