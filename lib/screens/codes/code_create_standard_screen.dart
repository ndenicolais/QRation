import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:free_map/free_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/screens/codes/code_details_screen.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/utils/code_type_text.dart';
import 'package:qration/utils/isbn_formatter.dart';
import 'package:qration/utils/validator.dart';
import 'package:qration/widgets/custom_button.dart';
import 'package:qration/widgets/custom_picker_field.dart';
import 'package:qration/widgets/custom_toast.dart';
import 'package:qration/widgets/full_screen_map.dart';

class CodeCreateStandardScreen extends StatefulWidget {
  final BarcodeType type;

  const CodeCreateStandardScreen({super.key, required this.type});

  @override
  CodeCreateStandardScreenState createState() =>
      CodeCreateStandardScreenState();
}

class CodeCreateStandardScreenState extends State<CodeCreateStandardScreen> {
  final CodesService _codesService = CodesService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CodeTypeText _contentType;
  Color _eyeColor = Colors.black;
  int _eyeRounded = 0;
  Color _moduleColor = Colors.black;
  int _moduleRounded = 0;
  final Map<String, TextEditingController> _controllers = {};
  String selectedPrefix = '+39';
  String selectedEncryption = 'WPA/WPA2';
  bool isHiddenNetwork = false;
  final List<String> encryptionOptions = ['WPA/WPA2', 'WEP', 'None'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.h,
              children: [
                _buildInputFields(context),
                _buildQrCodeDisplay(context),
                _buildQrCodeAspect(context),
                _buildGenerateButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _contentType = CodeTypeText.fromBarcodeType(widget.type, '');
  }

  void _initializeControllers() {
    _controllers.addAll({
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

  String? _validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return AppLocalizations.of(context)!.validator_email_required;
    }
    String? emailError = val.emailValidationError(context);
    if (emailError != null) {
      return '${AppLocalizations.of(context)!.validator_email_error} $emailError';
    }
    return null;
  }

  void _showLocationPicker() async {
    await Get.to(
      () => FullScreenMap(
        onLocationPicked: (LatLng location) {
          setState(() {
            _controllers['geoLatitude']?.text = location.latitude.toString();
            _controllers['geoLongitude']?.text = location.longitude.toString();
          });
        },
      ),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 500),
    );
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
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _showLocationPicker,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  MingCuteIcons.mgc_location_fill,
                  size: 22.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12.w),
                Text(
                  AppLocalizations.of(context)!
                      .code_create_standard_screen_geo_select_button,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      BarcodeType.wifi: Column(
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
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedEncryption,
                    items: encryptionOptions.map((String encryption) {
                      return DropdownMenuItem<String>(
                        value: encryption,
                        child: Text(
                          encryption,
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedEncryption = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .code_create_standard_screen_wifi_hidden_label,
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Checkbox(
                    checkColor: Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: isHiddenNetwork,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isHiddenNetwork = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      BarcodeType.calendarEvent: Column(
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
            controller: _controllers['eventStartDate']!,
            isDatePicker: true,
          ),
          CustomPickerField(
            label: AppLocalizations.of(context)!
                .code_create_standard_screen_calendar_end_date_label,
            controller: _controllers['eventEndDate']!,
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
    final controller =
        _controllers.putIfAbsent(controllerKey, () => TextEditingController());

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
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(labelText: label),
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
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
    final controller =
        _controllers.putIfAbsent(controllerKey, () => TextEditingController());

    return Row(
      children: [
        CountryCodePicker(
          onChanged: (countryCode) {
            setState(() {
              selectedPrefix = countryCode.dialCode!;
            });
          },
          initialSelection: 'IT',
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          textStyle: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            cursorColor: Theme.of(context).colorScheme.tertiary,
            decoration: InputDecoration(labelText: label),
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
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

  bool _isFieldEmpty(String fieldName, String fieldValue) {
    if (fieldValue.isEmpty) {
      showErrorToast(context,
          '${AppLocalizations.of(context)!.code_create_standard_screen_validator_field_a} $fieldName ${AppLocalizations.of(context)!.code_create_standard_screen_validator_field_b}');
      return true;
    }
    return false;
  }

  Future<void> _createQrCode(String content) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final defaultController = _controllers['default'];

    setState(() {
      if (defaultController != null) {
        defaultController.text = content;
      }
    });

    Barcode barcode = Barcode(
      rawValue: content,
      type: widget.type,
    );

    CodeModel code = CodeModel(
      id: '',
      barcode: barcode,
      date: DateTime.now(),
      source: CodeSource.created,
      eyeColor: _eyeColor,
      eyeRounded: _eyeRounded,
      moduleColor: _moduleColor,
      moduleRounded: _moduleRounded,
    );

    try {
      await _codesService.addCode(code);
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!
              .code_create_standard_screen_toast_success,
        );
      }
      Get.off(() => CodeDetailsScreen(code: code));
    } catch (e) {
      if (mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.code_create_standard_screen_toast_error} $e');
      }
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        _contentType.type,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildQrCodeDisplay(BuildContext context) {
    final defaultController = _controllers['default'];

    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Center(
        child: QrImageView(
          data: (defaultController?.text.isEmpty ?? true)
              ? " "
              : defaultController!.text,
          size: 220.sp,
          backgroundColor: Colors.white,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
          eyeStyle: QrEyeStyle(
            eyeShape: _eyeRounded == 1 ? QrEyeShape.circle : QrEyeShape.square,
            color: _eyeColor,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: _moduleRounded == 1
                ? QrDataModuleShape.circle
                : QrDataModuleShape.square,
            color: _moduleColor,
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeAspect(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .code_create_standard_screen_eye_title,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildEyeCustomizationRow(),
              ],
            ),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .code_create_standard_screen_module_title,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildModuleCustomizationRow(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEyeCustomizationRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.code_create_standard_screen_eye_color,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: () => pickColor(context, true),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: _eyeColor,
              borderRadius: BorderRadius.circular(15.r),
              border:
                  Border.all(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.code_create_standard_screen_eye_rounded,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Switch(
          value: _eyeRounded == 1,
          onChanged: (value) {
            setState(() {
              _eyeRounded = value ? 1 : 0;
            });
          },
          activeColor: Theme.of(context).colorScheme.tertiary,
          activeTrackColor: Theme.of(context).colorScheme.secondary,
          inactiveThumbColor: Theme.of(context).colorScheme.secondary,
          inactiveTrackColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildModuleCustomizationRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!
              .code_create_standard_screen_module_color,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: () => pickColor(context, false),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: _moduleColor,
              borderRadius: BorderRadius.circular(15.r),
              border:
                  Border.all(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!
              .code_create_standard_screen_module_rounded,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Switch(
          value: _moduleRounded == 1,
          onChanged: (value) {
            setState(() {
              _moduleRounded = value ? 1 : 0;
            });
          },
          activeColor: Theme.of(context).colorScheme.tertiary,
          activeTrackColor: Theme.of(context).colorScheme.secondary,
          inactiveThumbColor: Theme.of(context).colorScheme.secondary,
          inactiveTrackColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  void pickColor(BuildContext context, bool isEyeColor) async {
    Color color = isEyeColor ? _eyeColor : _moduleColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          AppLocalizations.of(context)!
              .code_create_standard_screen_dialog_color_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (newColor) {
              setState(() {
                if (isEyeColor) {
                  _eyeColor = newColor;
                } else {
                  _moduleColor = newColor;
                }
              });
            },
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!
                  .code_create_standard_screen_dialog_color_select,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    return CustomButton(
      title: AppLocalizations.of(context)!
          .code_create_standard_screen_create_button,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      isOutline: true,
      onPressed: () async {
        final content = _generateContent();
        if (content != null) {
          await _createQrCode(content);
        }
      },
    );
  }

  String? _generateContent() {
    switch (widget.type) {
      case BarcodeType.url:
        return _generateUrlContent();
      case BarcodeType.email:
        return _generateEmailContent();
      case BarcodeType.phone:
        return _generatePhoneContent();
      case BarcodeType.sms:
        return _generateSmsContent();
      case BarcodeType.contactInfo:
        return _generateContactInfoContent();
      case BarcodeType.geo:
        return _generateGeoContent();
      case BarcodeType.wifi:
        return _generateWifiContent();
      case BarcodeType.calendarEvent:
        return _generateCalendarEventContent();
      case BarcodeType.product:
        return _generateProductContent();
      case BarcodeType.isbn:
        return _generateIsbnContent();
      default:
        return _generateDefaultContent();
    }
  }

  String? _generateUrlContent() {
    final content = _controllers['url']?.text.trim() ?? '';
    if (_isFieldEmpty(
        AppLocalizations.of(context)!.code_create_standard_screen_url_label,
        content)) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.code_create_standard_screen_validator_url,
      );
      return null;
    } else if (!(content.startsWith('www') || content.startsWith('http'))) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!
            .code_create_standard_screen_error_url_length,
      );
      return null;
    } else if (content.length <= 7) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.code_create_standard_screen_validator_url,
      );
      return null;
    }
    return content;
  }

  String? _generateEmailContent() {
    final emailAddress = _controllers['emailAddress']?.text.trim() ?? '';
    final emailSubject = _controllers['emailSubject']?.text.trim() ?? '';
    final emailBody = _controllers['emailBody']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_email_address_label,
      emailAddress,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_email_subject_label,
      emailSubject,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_email_body_label,
      emailBody,
    )) {
      return null;
    }

    final emailValidationError = _validateEmail(emailAddress);
    if (emailValidationError != null) {
      showErrorToast(context, emailValidationError);
      return null;
    }

    return 'MATMSG:TO:$emailAddress;SUB:$emailSubject;BODY:$emailBody;;';
  }

  String? _generatePhoneContent() {
    var content = _controllers['phone']?.text.trim() ?? '';
    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_phone_label,
      content,
    )) {
      return null;
    }
    return 'tel:$selectedPrefix$content';
  }

  String? _generateSmsContent() {
    final smsPhone = _controllers['smsPhone']?.text.trim() ?? '';
    final smsMessage = _controllers['smsMessage']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_sms_phone_label,
      smsPhone,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_sms_message_label,
      smsMessage,
    )) {
      return null;
    }

    return 'SMSTO:$selectedPrefix$smsPhone:$smsMessage';
  }

  String? _generateContactInfoContent() {
    final contactName = _controllers['contactName']?.text.trim() ?? '';
    final contactSurname = _controllers['contactSurname']?.text.trim() ?? '';
    final contactPhone = _controllers['contactPhone']?.text.trim() ?? '';
    final contactEmail = _controllers['contactEmail']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_contact_name_label,
      contactName,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_contact_surname_label,
      contactSurname,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_contact_phone_label,
      contactPhone,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_contact_email_label,
      contactEmail,
    )) {
      return null;
    }

    final emailValidationError = _validateEmail(contactEmail);
    if (emailValidationError != null) {
      showErrorToast(context, emailValidationError);
      return null;
    }

    return '''BEGIN:VCARD
VERSION:2.1
FN:$contactName $contactSurname
N:$contactSurname;$contactName
TEL:$selectedPrefix$contactPhone
EMAIL:$contactEmail
END:VCARD''';
  }

  String? _generateGeoContent() {
    final geoLatitude = _controllers['geoLatitude']?.text.trim() ?? '';
    final geoLongitude = _controllers['geoLongitude']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_geo_latitude_label,
      geoLatitude,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_geo_longitude_label,
      geoLongitude,
    )) {
      return null;
    }

    return 'geo:$geoLatitude,$geoLongitude';
  }

  String? _generateWifiContent() {
    final wifiSsid = _controllers['wifiSsid']?.text.trim() ?? '';
    final wifiPassword = _controllers['wifiPassword']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_wifi_ssid_label,
      wifiSsid,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_wifi_password_label,
      wifiPassword,
    )) {
      return null;
    }

    return selectedEncryption == 'WPA/WPA2'
        ? 'WIFI:T:WPA;S:$wifiSsid;P:$wifiPassword;H:${isHiddenNetwork.toString()};'
        : 'WIFI:T:$selectedEncryption;S:$wifiSsid;P:$wifiPassword;H:${isHiddenNetwork.toString()};';
  }

  String? _generateCalendarEventContent() {
    final eventTitle = _controllers['eventTitle']?.text.trim() ?? '';
    var eventStartDate = _controllers['eventStartDate']?.text.trim() ?? '';
    var eventEndDate = _controllers['eventEndDate']?.text.trim() ?? '';
    final eventLocation = _controllers['eventLocation']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_calendar_title_label,
      eventTitle,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_calendar_start_date_label,
      eventStartDate,
    )) {
      return null;
    }
    if (_isFieldEmpty(
      AppLocalizations.of(context)!
          .code_create_standard_screen_calendar_end_date_label,
      eventEndDate,
    )) {
      return null;
    }

    String formatDateTime(String date) {
      final dateTime = DateTime.parse(date);
      return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0]}Z';
    }

    eventStartDate = formatDateTime(eventStartDate);
    eventEndDate = formatDateTime(eventEndDate);

    return 'BEGIN:VCALENDAR\r\n'
        'VERSION:2.0\r\n'
        'BEGIN:VEVENT\r\n'
        'DTSTART:$eventStartDate\r\n'
        'DTEND:$eventEndDate\r\n'
        'SUMMARY:$eventTitle\r\n'
        'LOCATION:$eventLocation\r\n'
        'END:VEVENT\r\n'
        'END:VCALENDAR';
  }

  String? _generateProductContent() {
    final product = _controllers['product']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_product_label,
      product,
    )) {
      return null;
    }

    return product;
  }

  String? _generateIsbnContent() {
    final isbn = _controllers['isbn']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_isbn_label,
      isbn,
    )) {
      return null;
    }

    return isbn;
  }

  String? _generateDefaultContent() {
    final content = _controllers['default']?.text.trim() ?? '';

    if (_isFieldEmpty(
      AppLocalizations.of(context)!.code_create_standard_screen_text_label,
      content,
    )) {
      return null;
    }
    return content;
  }
}
