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
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/core/utils/logo_saver.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

class CodeCreateSocialController extends GetxController {
  CodeCreateSocialController({required this.socialMedia})
      : urlController = TextEditingController(
          text: initialUrlFor(socialMedia.url),
        );

  final CodeSocial socialMedia;
  final CodesRepository _codesService = Get.find<CodesRepository>();

  final TextEditingController urlController;
  final spotifyArtistController = TextEditingController();
  final spotifySongController = TextEditingController();
  final whatsappController = TextEditingController();

  final eyeColor = Colors.black.obs;
  final eyeRounded = 0.obs;
  final moduleColor = Colors.black.obs;
  final moduleRounded = 0.obs;
  final Rx<String?> logoPath = Rx<String?>(null);
  final selectedPrefix = '+39'.obs;
  final isLoading = false.obs;

  CodeModel? lastCreatedCode;
  Object? lastError;

  bool get isSpotify => socialMedia.name == 'Spotify';
  bool get isWhatsApp => socialMedia.name == 'WhatsApp';

  @override
  void onClose() {
    urlController.dispose();
    spotifyArtistController.dispose();
    spotifySongController.dispose();
    whatsappController.dispose();
    super.onClose();
  }

  static String initialUrlFor(String socialMediaUrl) {
    if (socialMediaUrl.contains('spotify.com')) {
      return 'https://open.spotify.com/';
    } else if (socialMediaUrl.contains('whatsapp.com')) {
      return 'https://wa.me/';
    }
    return '';
  }

  bool hasContent() =>
      urlController.text.isNotEmpty ||
      spotifyArtistController.text.isNotEmpty ||
      spotifySongController.text.isNotEmpty ||
      whatsappController.text.isNotEmpty;

  /// Builds the encoded content for the current social network; empty when
  /// required input is missing.
  String buildContent() {
    if (isSpotify) {
      final artist = spotifyArtistController.text.trim();
      final song = spotifySongController.text.trim();
      if (artist.isNotEmpty && song.isNotEmpty) {
        return 'spotify:search:$artist;$song';
      }
      return 'https://open.spotify.com/';
    }
    if (isWhatsApp) {
      final phoneNumber = whatsappController.text.trim();
      if (phoneNumber.isEmpty) return '';
      return 'https://wa.me/${selectedPrefix.value}$phoneNumber';
    }
    return urlController.text.trim();
  }

  Future<void> pickLogo() async {
    final path = await pickAndSaveLogo();
    if (path != null) logoPath.value = path;
  }

  void removeLogo() => logoPath.value = null;

  Future<bool> createQrCode(String content) async {
    isLoading.value = true;
    final code = CodeModel(
      id: '',
      barcode: Barcode(rawValue: content, type: BarcodeType.url),
      date: DateTime.now(),
      source: CodeSource.created,
      eyeColor: eyeColor.value,
      eyeRounded: eyeRounded.value,
      moduleColor: moduleColor.value,
      moduleRounded: moduleRounded.value,
      socialMedia: socialMedia,
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
