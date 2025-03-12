import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qration/models/code_model.dart';
import 'package:qration/models/code_social_model.dart';
import 'package:qration/screens/codes/code_details_screen.dart';
import 'package:qration/services/codes_service.dart';
import 'package:qration/widgets/custom_button.dart';
import 'package:qration/widgets/custom_toast.dart';

class CodeCreateSocialScreen extends StatefulWidget {
  final CodeSocial socialMedia;

  const CodeCreateSocialScreen({super.key, required this.socialMedia});

  @override
  CodeCreateSocialScreenState createState() => CodeCreateSocialScreenState();
}

class CodeCreateSocialScreenState extends State<CodeCreateSocialScreen> {
  final CodesService _codesService = CodesService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController urlController;
  late TextEditingController spotifyArtistController;
  late TextEditingController spotifySongController;
  late TextEditingController whatsappController;
  Color _eyeColor = Colors.black;
  int _eyeRounded = 0;
  Color _moduleColor = Colors.black;
  int _moduleRounded = 0;
  late String _contentType;
  final String _content = '';
  String selectedPrefix = '+39';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _contentType = widget.socialMedia.name;
    urlController = TextEditingController(
      text: _getInitialUrlForSocialMedia(widget.socialMedia.url),
    );
    spotifyArtistController = TextEditingController();
    spotifySongController = TextEditingController();
    whatsappController = TextEditingController();
  }

  @override
  void dispose() {
    urlController.dispose();
    spotifyArtistController.dispose();
    spotifySongController.dispose();
    whatsappController.dispose();
    super.dispose();
  }

  String _getInitialUrlForSocialMedia(String socialMediaUrl) {
    if (socialMediaUrl.contains("spotify.com")) {
      return 'https://open.spotify.com/';
    } else if (socialMediaUrl.contains("whatsapp.com")) {
      return 'https://wa.me/';
    }
    return '';
  }

  String _buildUrlForSocialMedia() {
    if (widget.socialMedia.name == 'Spotify') {
      final artist = spotifyArtistController.text.trim();
      final song = spotifySongController.text.trim();
      if (artist.isNotEmpty && song.isNotEmpty) {
        return 'spotify:search:$artist;$song';
      } else {
        return 'https://open.spotify.com/';
      }
    }

    if (widget.socialMedia.name == 'WhatsApp') {
      final phoneNumber = whatsappController.text.trim();
      if (phoneNumber.isEmpty) {
        return '';
      }
      final fullPhoneNumber = selectedPrefix + phoneNumber;
      return 'https://wa.me/$fullPhoneNumber';
    }
    return urlController.text;
  }

  Future<void> _createQrCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String content = _buildUrlForSocialMedia().trim();

    if (content.isEmpty) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.code_create_social_screen_validator_url,
      );
      return;
    }

    Barcode barcode = Barcode(
      rawValue: content,
      type: BarcodeType.url,
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
      socialMedia: widget.socialMedia,
    );

    try {
      await _codesService.addCode(code);
      if (mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.code_create_social_screen_toast_success,
        );
      }

      Get.off(() => CodeDetailsScreen(code: code));
    } catch (e) {
      if (mounted) {
        showErrorToast(context,
            '${AppLocalizations.of(context)!.code_create_social_screen_toast_error} $e');
      }
    }
  }

  Widget _buildInputFields(BuildContext context) {
    if (widget.socialMedia.name == 'Spotify') {
      return Column(
        children: [
          _buildSpotifyField(
            label: AppLocalizations.of(context)!
                .code_create_social_screen_spotify_artist_label,
            controller: spotifyArtistController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!
                    .code_create_social_screen_spotify_artist_validator;
              }
              return null;
            },
          ),
          _buildSpotifyField(
            label: AppLocalizations.of(context)!
                .code_create_social_screen_spotify_song_label,
            controller: spotifySongController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!
                    .code_create_social_screen_spotify_song_validator;
              }
              return null;
            },
          ),
        ],
      );
    } else if (widget.socialMedia.name == 'WhatsApp') {
      return _buildPhoneNumberField();
    } else {
      return _buildTextField(
        label:
            AppLocalizations.of(context)!.code_create_social_screen_url_label,
        controller: urlController,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return AppLocalizations.of(context)!
                .code_create_social_screen_url_validator;
          }
          if ([
            'https://www.youtube.com/',
            'https://www.facebook.com/',
            'https://www.instagram.com/',
            'https://www.tiktok.com/',
            'https://t.me/',
            'https://www.linkedin.com/',
            'https://x.com/',
            'https://www.pinterest.com/',
            'https://open.spotify.com/',
            'https://wa.me/',
            'https://'
          ].contains(value.trim())) {
            return AppLocalizations.of(context)!
                .code_create_social_screen_url_details_validator;
          }
          return null;
        },
      );
    }
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    FormFieldValidator<String>? validator,
  }) {
    final decoration = InputDecoration(
      labelText: label,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.url,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: decoration,
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!
              .code_create_social_screen_error_url;
        }
        if (value.length <= 7) {
          return AppLocalizations.of(context)!
              .code_create_social_screen_error_url_length;
        }
        if (!(value.startsWith('www') || value.startsWith('http'))) {
          return AppLocalizations.of(context)!
              .code_create_social_screen_error_url_www;
        }
        if (validator != null) {
          return validator(value);
        }
        return null;
      },
    );
  }

  Widget _buildSpotifyField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    FormFieldValidator<String>? validator,
  }) {
    final decoration = InputDecoration(
      labelText: label,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.url,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: decoration,
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.secondary,
      ),
      validator: (value) {
        if (validator != null) {
          return validator(value);
        }
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .code_create_social_screen_whatsapp_label),
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!
                        .code_create_social_screen_whatsapp_validator;
                  }
                  final regex = RegExp(r'^\d+$');
                  if (!regex.hasMatch(value) || value.length < 7) {
                    return AppLocalizations.of(context)!
                        .code_create_social_screen_whatsapp_validator;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
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
        _contentType,
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
    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Center(
        child: QrImageView(
          data: _content,
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
                      .code_create_social_screen_eye_title,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
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
                      .code_create_social_screen_module_title,
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).colorScheme.secondary,
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
          AppLocalizations.of(context)!.code_create_social_screen_eye_color,
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
          AppLocalizations.of(context)!.code_create_social_screen_eye_rounded,
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
          AppLocalizations.of(context)!.code_create_social_screen_module_color,
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
              .code_create_social_screen_module_rounded,
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          AppLocalizations.of(context)!
              .code_create_social_screen_dialog_color_text,
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
                  .code_create_social_screen_dialog_color_select,
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
      title:
          AppLocalizations.of(context)!.code_create_social_screen_create_button,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      isOutline: true,
      onPressed: () {
        _createQrCode();
      },
    );
  }
}
