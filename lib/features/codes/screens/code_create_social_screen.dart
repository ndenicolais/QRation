// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
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
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:qration/features/codes/controllers/code_create_social_controller.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/features/codes/widgets/code_create/code_create_app_bar.dart';
import 'package:qration/features/codes/widgets/code_create/discard_dialog.dart';
import 'package:qration/features/codes/widgets/code_create/generate_button.dart';
import 'package:qration/features/codes/widgets/code_create/qr_preview.dart';
import 'package:qration/features/codes/widgets/code_create/qr_style_customizer.dart';
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _confirmBack(context);
      },
      child: Scaffold(
        appBar: CodeCreateAppBar(
          title: widget.socialMedia.name,
          hasContent: _controller.hasContent,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  SectionCard(
                    title: AppLocalizations.of(context)!
                        .code_details_screen_content_title,
                    icon: widget.socialMedia.icon,
                    child: _buildInputFields(context),
                  ),
                  QrPreview(
                    style: _controller,
                    contentListenable: Listenable.merge([
                      _controller.urlController,
                      _controller.spotifyArtistController,
                      _controller.spotifySongController,
                      _controller.whatsappController,
                    ]),
                    data: _controller.buildContent,
                  ),
                  QrStyleCustomizer(style: _controller),
                  Obx(() => GenerateButton(
                        label: AppLocalizations.of(context)!
                            .code_create_social_screen_create_button,
                        isLoading: _controller.isLoading.value,
                        onPressed: _createQrCode,
                      )),
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
    _controller = Get.find<CodeCreateSocialController>();
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
        spacing: 12,
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
      decoration: decoration,
      style: Theme.of(context).textTheme.bodyLarge,
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
      decoration: decoration,
      style: Theme.of(context).textTheme.bodyLarge,
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
              textStyle: Theme.of(context).textTheme.labelLarge,
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
}
