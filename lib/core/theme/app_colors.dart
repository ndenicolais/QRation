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

class AppColors {
  // Brand colors
  static const Color qrBlue = Color(0xFF274060);
  static const Color qrBlueDark = Color(0xFF1A2E46);
  static const Color qrBlueLight = Color(0xFF3A5A82);
  static const Color qrGold = Color(0xFFCCA775);
  static const Color qrGoldDark = Color(0xFFB8935E);
  static const Color qrGoldLight = Color(0xFFDDBB90);
  static const Color qrWhite = Color(0xFFFFFFFF);

  // Surface colors - Light
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF5F3F0);
  static const Color cardLight = Color(0xFFFAF8F5);
  static const Color dividerLight = Color(0xFFE8E4DF);

  // Surface colors - Dark
  static const Color surfaceDark = Color(0xFF1A2E46);
  static const Color surfaceVariantDark = Color(0xFF1F3554);
  static const Color cardDark = Color(0xFF243D5E);
  static const Color dividerDark = Color(0xFF2D4A6E);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF274060);
  // At least 5:1 on surface, card and surfaceVariant (WCAG AA needs 4.5:1).
  static const Color textSecondaryLight = Color(0xFF4C6A8D);
  static const Color textHintLight = Color(0xFF9BAFC4);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFCCA775);
  static const Color textHintDark = Color(0xFF7A9BBF);

  // Status colors
  static const Color success = Color(0xFF449777);
  static const Color successLight = Color(0xFFEAF8EA);
  static const Color error = Color(0xFFD80032);
  static const Color errorLight = Color(0xFFFFEBEA);
  static const Color warning = Color(0xFFE8A020);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF274060);
  static const Color infoLight = Color(0xFFE8EFF7);

  // Scanner overlay
  static const Color scannerOverlay = Color(0xCC000000);
  static const Color scannerCorner = Color(0xFFCCA775);
  static const Color qrMarkerColor = Color(0xFFE12729);

  // Legacy aliases kept during migration cleanup
  static const Color toastLightGreen = successLight;
  static const Color toastDarkGreen = success;
  static const Color toastLightRed = errorLight;
  static const Color toastDarkRed = error;
  static const Color successColor = success;
  static const Color errorColor = error;
}
