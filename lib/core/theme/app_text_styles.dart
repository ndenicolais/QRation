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
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_colors.dart';

class AppTextStyles {
  // Display
  static TextStyle displayLarge({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle displayMedium({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle displaySmall({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  // Headline
  static TextStyle headlineLarge({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle headlineMedium({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle headlineSmall({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  // Title
  static TextStyle titleLarge({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle titleMedium({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.15,
      );

  static TextStyle titleSmall({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.1,
      );

  // Body
  static TextStyle bodyLarge({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.5,
      );

  static TextStyle bodyMedium({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.25,
      );

  static TextStyle bodySmall({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ??
            (dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        letterSpacing: 0.4,
      );

  // Label
  static TextStyle labelLarge({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall({Color? color, bool dark = false}) =>
      AppFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ??
            (dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        letterSpacing: 0.5,
      );
}
