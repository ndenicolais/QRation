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
import 'package:qration/core/utils/logo_saver.dart';

/// Visual style of a QR code being created (eyes, modules, optional logo),
/// shared by the standard and social creation controllers.
mixin QrStyleMixin on GetxController {
  final eyeColor = Colors.black.obs;
  final eyeRounded = 0.obs;
  final moduleColor = Colors.black.obs;
  final moduleRounded = 0.obs;
  final Rx<String?> logoPath = Rx<String?>(null);

  Future<void> pickLogo() async {
    final path = await pickAndSaveLogo();
    if (path != null) logoPath.value = path;
  }

  void removeLogo() => logoPath.value = null;
}
