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
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/features/codes/controllers/code_create_social_controller.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/codes/widgets/code_create/discard_dialog.dart';
import 'package:qration/core/widgets/app_button.dart';
import 'package:qration/core/widgets/app_toast.dart';

class CodeCreateSocialScreen extends StatefulWidget {
  final CodeSocial socialMedia;

  const CodeCreateSocialScreen({super.key, required this.socialMedia});

  @override
  CodeCreateSocialScreenState createState() => CodeCreateSocialScreenState();
}

class CodeCreateSocialScreenState extends State<CodeCreateSocialScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CodeCreateSocialController _controller;
  final String _content = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _confirmBack(context);
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
    _controller = Get.put(
      CodeCreateSocialController(socialMedia: widget.socialMedia),
    );
  }

  @override
  void dispose() {
    Get.delete<CodeCreateSocialController>();
    super.dispose();
  }

  Future<void> _confirmBack(BuildContext context) async {
    if (!_controller.hasContent()) {
      Get.back();
      return;
    }
    final shouldPop = await showDiscardDialog(context);
    if (shouldPop && context.mounted) Get.back();
  }

  Future<void> _createQrCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final content = _controller.buildContent();

    if (content.isEmpty) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.code_create_social_screen_validator_url,
      );
      return;
    }

    final success = await _controller.createQrCode(content);
    if (!mounted) return;
    if (success) {
      showSuccessToast(
        context,
        AppLocalizations.of(context)!.code_create_social_screen_toast_success,
      );
      Get.offNamed(AppRoutes.codeDetails,
          arguments: _controller.lastCreatedCode);
    } else {
      showErrorToast(context,
          '${AppLocalizations.of(context)!.code_create_social_screen_toast_error} ${_controller.lastError}');
    }
  }

  Widget _buildInputFields(BuildContext context) {
    if (_controller.isSpotify) {
      return Column(
        children: [
          _buildSpotifyField(
            label: AppLocalizations.of(context)!
                .code_create_social_screen_spotify_artist_label,
            controller: _controller.spotifyArtistController,
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
            controller: _controller.spotifySongController,
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
    } else if (_controller.isWhatsApp) {
      return _buildPhoneNumberField();
    } else {
      return _buildTextField(
        label:
            AppLocalizations.of(context)!.code_create_social_screen_url_label,
        controller: _controller.urlController,
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
                _controller.selectedPrefix.value = countryCode.dialCode!;
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
                controller: _controller.whatsappController,
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
        onPressed: () => _confirmBack(context),
      ),
      title: Text(
        widget.socialMedia.name,
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
        child: Obx(() {
          final logoPath = _controller.logoPath.value;
          return PrettyQrView.data(
            data: _content,
            errorCorrectLevel: logoPath != null
                ? QrErrorCorrectLevel.H
                : QrErrorCorrectLevel.M,
            decoration: buildQrDecoration(
              eyeColor: _controller.eyeColor.value,
              eyeRounded: _controller.eyeRounded.value,
              moduleColor: _controller.moduleColor.value,
              moduleRounded: _controller.moduleRounded.value,
              logoImage: logoPath != null ? FileImage(File(logoPath)) : null,
            ),
          );
        }),
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
        Obx(() {
          final logoPath = _controller.logoPath.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _controller.pickLogo,
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                    image: logoPath != null
                        ? DecorationImage(
                            image: FileImage(File(logoPath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: logoPath == null
                      ? Icon(Icons.add_photo_alternate_outlined,
                          color: Theme.of(context).colorScheme.secondary)
                      : null,
                ),
              ),
              if (logoPath != null)
                IconButton(
                  onPressed: _controller.removeLogo,
                  icon: Icon(Icons.close,
                      color: Theme.of(context).colorScheme.secondary),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEyeCustomizationRow() {
    return Obx(() => Column(
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
                  color: _controller.eyeColor.value,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              AppLocalizations.of(context)!
                  .code_create_social_screen_eye_rounded,
              style: AppFonts.montserrat(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Switch(
              value: _controller.eyeRounded.value == 1,
              onChanged: (value) =>
                  _controller.eyeRounded.value = value ? 1 : 0,
              activeColor: Theme.of(context).colorScheme.tertiary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
  }

  Widget _buildModuleCustomizationRow() {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .code_create_social_screen_module_color,
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
                  color: _controller.moduleColor.value,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary),
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
              value: _controller.moduleRounded.value == 1,
              onChanged: (value) =>
                  _controller.moduleRounded.value = value ? 1 : 0,
              activeColor: Theme.of(context).colorScheme.tertiary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ));
  }

  void pickColor(BuildContext context, bool isEyeColor) async {
    final color =
        isEyeColor ? _controller.eyeColor.value : _controller.moduleColor.value;

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
              if (isEyeColor) {
                _controller.eyeColor.value = newColor;
              } else {
                _controller.moduleColor.value = newColor;
              }
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
