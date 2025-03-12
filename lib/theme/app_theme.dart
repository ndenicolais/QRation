import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qration/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.qrWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.qrWhite,
        onPrimary: AppColors.qrGold,
        secondary: AppColors.qrBlue,
        onSecondary: AppColors.qrWhite,
        tertiary: AppColors.qrGold,
        onTertiary: AppColors.qrBlue,
        onError: AppColors.errorColor,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.qrWhite),
        checkColor: WidgetStateProperty.all(AppColors.qrBlue),
        side: BorderSide(
          color: AppColors.qrGold,
          width: 1,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.qrWhite,
        surfaceTintColor: AppColors.qrGold,
        headerBackgroundColor: AppColors.qrBlue,
        headerForegroundColor: AppColors.qrGold,
        todayBackgroundColor: WidgetStateProperty.all(AppColors.qrGold),
        todayForegroundColor: WidgetStateProperty.all(AppColors.qrBlue),
        dividerColor: AppColors.qrBlue,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.qrGold,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.qrBlue,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.qrBlue,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.montserrat(
            color: AppColors.qrGold,
          ),
          foregroundColor: AppColors.qrBlue,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.qrGold,
        selectionHandleColor: AppColors.qrGold,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(),
        displayMedium: GoogleFonts.montserrat(),
        displaySmall: GoogleFonts.montserrat(),
        headlineLarge: GoogleFonts.montserrat(),
        headlineMedium: GoogleFonts.montserrat(),
        headlineSmall: GoogleFonts.montserrat(),
        titleLarge: GoogleFonts.montserrat(),
        titleMedium: GoogleFonts.montserrat(),
        titleSmall: GoogleFonts.montserrat(),
        bodyLarge: GoogleFonts.montserrat(),
        bodyMedium: GoogleFonts.montserrat(),
        bodySmall: GoogleFonts.montserrat(),
        labelLarge: GoogleFonts.montserrat(),
        labelMedium: GoogleFonts.montserrat(),
        labelSmall: GoogleFonts.montserrat(),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.qrWhite,
        dialBackgroundColor: AppColors.qrBlue,
        dialHandColor: AppColors.qrWhite,
        dialTextColor: AppColors.qrGold,
        helpTextStyle: GoogleFonts.montserrat(
          color: AppColors.qrGold,
        ),
        hourMinuteColor: AppColors.qrBlue,
        hourMinuteTextColor: AppColors.qrGold,
      ),
    );
  }

  static ThemeData darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.qrBlue,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.qrBlue,
        onPrimary: AppColors.qrWhite,
        secondary: AppColors.qrGold,
        onSecondary: AppColors.qrBlue,
        tertiary: AppColors.qrWhite,
        onTertiary: AppColors.qrGold,
        onError: AppColors.errorColor,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.qrBlue),
        checkColor: WidgetStateProperty.all(AppColors.qrWhite),
        side: BorderSide(
          color: AppColors.qrGold,
          width: 1,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.qrBlue,
        surfaceTintColor: AppColors.qrWhite,
        headerBackgroundColor: AppColors.qrGold,
        headerForegroundColor: AppColors.qrWhite,
        todayBackgroundColor: WidgetStateProperty.all(AppColors.qrWhite),
        todayForegroundColor: WidgetStateProperty.all(AppColors.qrGold),
        dividerColor: AppColors.qrGold,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.montserrat(
          color: AppColors.qrWhite,
        ),
        errorStyle: GoogleFonts.montserrat(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w600,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.errorColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.qrGold,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.qrGold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.montserrat(
            color: AppColors.qrWhite,
          ),
          foregroundColor: AppColors.qrGold,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.qrWhite,
        selectionHandleColor: AppColors.qrWhite,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(),
        displayMedium: GoogleFonts.montserrat(),
        displaySmall: GoogleFonts.montserrat(),
        headlineLarge: GoogleFonts.montserrat(),
        headlineMedium: GoogleFonts.montserrat(),
        headlineSmall: GoogleFonts.montserrat(),
        titleLarge: GoogleFonts.montserrat(),
        titleMedium: GoogleFonts.montserrat(),
        titleSmall: GoogleFonts.montserrat(),
        bodyLarge: GoogleFonts.montserrat(),
        bodyMedium: GoogleFonts.montserrat(),
        bodySmall: GoogleFonts.montserrat(),
        labelLarge: GoogleFonts.montserrat(),
        labelMedium: GoogleFonts.montserrat(),
        labelSmall: GoogleFonts.montserrat(),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.qrBlue,
        dialBackgroundColor: AppColors.qrGold,
        dialHandColor: AppColors.qrBlue,
        dialTextColor: AppColors.qrWhite,
        helpTextStyle: GoogleFonts.montserrat(
          color: AppColors.qrWhite,
        ),
        hourMinuteColor: AppColors.qrGold,
        hourMinuteTextColor: AppColors.qrWhite,
      ),
    );
  }
}
