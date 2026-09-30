// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/utils/logo_saver.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/screens/code_details_screen.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/core/widgets/app_button.dart';
import 'package:qration/core/widgets/app_toast.dart';

class CodeCreateSocialScreen extends StatefulWidget {
  final CodeSocial socialMedia;

  const CodeCreateSocialScreen({super.key, required this.socialMedia});

  @override
  CodeCreateSocialScreenState createState() => CodeCreateSocialScreenState();
}

class CodeCreateSocialScreenState extends State<CodeCreateSocialScreen> {
  final CodesRepository _codesService = Get.find<CodesRepository>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController urlController;
  late TextEditingController spotifyArtistController;
  late TextEditingController spotifySongController;
  late TextEditingController whatsappController;
  Color _eyeColor = Colors.black;
  int _eyeRounded = 0;
  Color _moduleColor = Colors.black;
  int _moduleRounded = 0;
  String? _logoPath;
  late String _contentType;
  final String _content = '';
  String selectedPrefix = '+39';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final hasContent = urlController.text.isNotEmpty ||
            spotifyArtistController.text.isNotEmpty ||
            spotifySongController.text.isNotEmpty ||
            whatsappController.text.isNotEmpty;
        if (!hasContent) {
          Get.back();
          return;
        }
        final shouldPop = await _showDiscardDialog(context);
        if (shouldPop && context.mounted) Get.back();
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.r).copyWith(
              top: 20.h,
              bottom: 20.h,
            ),
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

  Future<bool> _showDiscardDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.discard_dialog_title),
            content: Text(l10n.discard_dialog_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.discard_dialog_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.discard_dialog_confirm),
              ),
            ],
          ),
        ) ??
        false;
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
      logoPath: _logoPath,
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
      style: AppFonts.montserrat(
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
      style: AppFonts.montserrat(
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
              textStyle: AppFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
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
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () async {
          final hasContent = urlController.text.isNotEmpty ||
              spotifyArtistController.text.isNotEmpty ||
              spotifySongController.text.isNotEmpty ||
              whatsappController.text.isNotEmpty;
          if (!hasContent) {
            Get.back();
            return;
          }
          final shouldPop = await _showDiscardDialog(context);
          if (shouldPop && context.mounted) Get.back();
        },
      ),
      title: Text(
        _contentType,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w500,
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
        child: PrettyQrView.data(
          data: _content,
          errorCorrectLevel:
              _logoPath != null ? QrErrorCorrectLevel.H : QrErrorCorrectLevel.M,
          decoration: buildQrDecoration(
            eyeColor: _eyeColor,
            eyeRounded: _eyeRounded,
            moduleColor: _moduleColor,
            moduleRounded: _moduleRounded,
            logoImage: _logoPath != null ? FileImage(File(_logoPath!)) : null,
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
                  style: AppFonts.montserrat(
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
                  style: AppFonts.montserrat(
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
        SizedBox(height: 20.h),
        Text(
          AppLocalizations.of(context)!.code_create_social_screen_logo_title,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickLogo,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
                  image: _logoPath != null
                      ? DecorationImage(
                          image: FileImage(File(_logoPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _logoPath == null
                    ? Icon(Icons.add_photo_alternate_outlined,
                        color: Theme.of(context).colorScheme.secondary)
                    : null,
              ),
            ),
            if (_logoPath != null)
              IconButton(
                onPressed: () => setState(() => _logoPath = null),
                icon: Icon(Icons.close,
                    color: Theme.of(context).colorScheme.secondary),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickLogo() async {
    final path = await pickAndSaveLogo();
    if (path != null) setState(() => _logoPath = path);
  }

  Widget _buildEyeCustomizationRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.code_create_social_screen_eye_color,
          style: AppFonts.montserrat(
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
          style: AppFonts.montserrat(
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
          style: AppFonts.montserrat(
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
          style: AppFonts.montserrat(
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
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
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
              style: AppFonts.montserrat(
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
    return AppButton.outlined(
      label:
          AppLocalizations.of(context)!.code_create_social_screen_create_button,
      foregroundColor: Theme.of(context).colorScheme.primary,
      width: 220.w,
      onPressed: () {
        _createQrCode();
      },
    );
  }
}
