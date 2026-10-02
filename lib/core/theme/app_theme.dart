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
import 'package:flutter/services.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/theme/app_radius.dart';

class AppTheme {
  static ThemeData lightTheme({Color primary = AppColors.qrBlue}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: AppColors.qrWhite,
        primaryContainer: AppColors.qrBlueLight,
        onPrimaryContainer: AppColors.qrWhite,
        secondary: AppColors.qrGold,
        onSecondary: primary,
        secondaryContainer: AppColors.qrGoldLight,
        onSecondaryContainer: AppColors.qrBlueDark,
        tertiary: primary,
        onTertiary: AppColors.qrWhite,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.surfaceVariantLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        outline: AppColors.dividerLight,
        error: AppColors.error,
        onError: AppColors.qrWhite,
      ),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          side: const BorderSide(color: AppColors.dividerLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: AppFonts.montserrat(
          color: primary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.surfaceLight,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textHintLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: AppColors.textHintLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primary,
            );
          }
          return AppFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textHintLight,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: AppFonts.montserrat(
          color: AppColors.textSecondaryLight,
          fontSize: 14,
        ),
        hintStyle: AppFonts.montserrat(
          color: AppColors.textHintLight,
          fontSize: 14,
        ),
        errorStyle: AppFonts.montserrat(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.qrWhite,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.qrWhite),
        side: const BorderSide(color: AppColors.qrGold, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraSmall)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.qrWhite;
          return AppColors.textHintLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return AppColors.dividerLight;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 0,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        headerBackgroundColor: primary,
        headerForegroundColor: AppColors.qrGold,
        todayBackgroundColor: WidgetStateProperty.all(AppColors.qrGold),
        todayForegroundColor: WidgetStateProperty.all(primary),
        dividerColor: AppColors.dividerLight,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        dialBackgroundColor: primary,
        dialHandColor: AppColors.qrGold,
        dialTextColor: AppColors.qrWhite,
        hourMinuteColor: primary,
        hourMinuteTextColor: AppColors.qrGold,
        helpTextStyle: AppFonts.montserrat(color: AppColors.textSecondaryLight),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.qrGold,
        selectionHandleColor: AppColors.qrGold,
        cursorColor: primary,
      ),
      textTheme: _buildTextTheme(isDark: false),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantLight,
        selectedColor: primary.withValues(alpha: 0.15),
        labelStyle: AppFonts.montserrat(fontSize: 13),
        side: const BorderSide(color: AppColors.dividerLight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primary,
        titleTextStyle: AppFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        subtitleTextStyle: AppFonts.montserrat(
          fontSize: 12,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  static ThemeData darkTheme({Color primary = AppColors.qrGold}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: AppColors.qrBlueDark,
        primaryContainer: AppColors.qrGoldDark,
        onPrimaryContainer: AppColors.qrBlueDark,
        secondary: AppColors.qrBlueLight,
        onSecondary: AppColors.qrWhite,
        secondaryContainer: AppColors.qrBlue,
        onSecondaryContainer: AppColors.qrGold,
        tertiary: primary,
        onTertiary: AppColors.qrBlueDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.dividerDark,
        error: AppColors.error,
        onError: AppColors.qrWhite,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          side: const BorderSide(color: AppColors.dividerDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: AppFonts.montserrat(
          color: primary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.surfaceDark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textHintDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: AppColors.textHintDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primary,
            );
          }
          return AppFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textHintDark,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: AppFonts.montserrat(
          color: AppColors.textSecondaryDark,
          fontSize: 14,
        ),
        hintStyle: AppFonts.montserrat(
          color: AppColors.textHintDark,
          fontSize: 14,
        ),
        errorStyle: AppFonts.montserrat(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.qrBlueDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.qrBlueDark),
        side: const BorderSide(color: AppColors.qrGold, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraSmall)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.qrBlueDark;
          }
          return AppColors.textHintDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return AppColors.dividerDark;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 0,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceDark,
        headerBackgroundColor: AppColors.qrBlueDark,
        headerForegroundColor: primary,
        todayBackgroundColor: WidgetStateProperty.all(AppColors.qrGold),
        todayForegroundColor: WidgetStateProperty.all(AppColors.qrBlueDark),
        dividerColor: AppColors.dividerDark,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceDark,
        dialBackgroundColor: AppColors.qrBlueDark,
        dialHandColor: primary,
        dialTextColor: primary,
        hourMinuteColor: AppColors.qrBlueDark,
        hourMinuteTextColor: primary,
        helpTextStyle: AppFonts.montserrat(color: AppColors.textSecondaryDark),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primary,
        selectionHandleColor: primary,
        cursorColor: primary,
      ),
      textTheme: _buildTextTheme(isDark: true),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle:
            AppFonts.montserrat(fontSize: 13, color: AppColors.textPrimaryDark),
        side: const BorderSide(color: AppColors.dividerDark),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primary,
        titleTextStyle: AppFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        subtitleTextStyle: AppFonts.montserrat(
          fontSize: 12,
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color primary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color secondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    // The app's type scale: screens use these roles through
    // `Theme.of(context).textTheme` instead of inline font sizes. Sizes not
    // set here (display/headline large and medium) keep the Material 3
    // defaults.
    TextStyle style(double size, Color color, [FontWeight? weight]) =>
        AppFonts.montserrat(fontSize: size, color: color, fontWeight: weight);
    const w500 = FontWeight.w500;
    return TextTheme(
      displayLarge: AppFonts.montserrat(color: primary),
      displayMedium: AppFonts.montserrat(color: primary),
      displaySmall: style(36, primary),
      headlineLarge: AppFonts.montserrat(color: primary, fontWeight: w500),
      headlineMedium: AppFonts.montserrat(color: primary, fontWeight: w500),
      // App name in Info, big numbers in Statistics.
      headlineSmall: style(24, primary, w500),
      // Dialog titles, prominent messages.
      titleLarge: style(20, primary, w500),
      // Group titles, empty/error state titles.
      titleMedium: style(18, primary, w500),
      // Section headers and card titles.
      titleSmall: style(15, primary, w500),
      bodyLarge: style(16, primary),
      // Default body text.
      bodyMedium: style(14, primary),
      // Secondary text: subtitles, captions, hints.
      bodySmall: style(12, secondary),
      // Row and tile titles, emphasized body text.
      labelLarge: style(14, primary, w500),
      // Small emphasized text: chips, badges, field labels.
      labelMedium: style(12, primary, w500),
      // Smallest text: tile labels, legends.
      labelSmall: style(11, secondary, w500),
    );
  }
}
