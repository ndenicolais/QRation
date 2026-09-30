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
import 'package:qration/core/theme/app_colors.dart';

/// A curated accent color choice: [light]/[dark] are pre-tuned shades of
/// the same hue, dark enough for white text/icons in light theme and
/// light enough for dark navy text/icons in dark theme, so contrast stays
/// readable across every themed component without a free-form picker.
class AccentPreset {
  const AccentPreset({
    required this.key,
    required this.light,
    required this.dark,
  });

  final String key;
  final Color light;
  final Color dark;
}

class AccentPresets {
  AccentPresets._();

  static const List<AccentPreset> all = [
    AccentPreset(key: 'blue', light: AppColors.qrBlue, dark: AppColors.qrGold),
    AccentPreset(
        key: 'green', light: Color(0xFF1F5C4A), dark: Color(0xFF6FCF9E)),
    AccentPreset(
        key: 'purple', light: Color(0xFF4A2E6E), dark: Color(0xFFB48AE0)),
    AccentPreset(key: 'red', light: Color(0xFF7A2333), dark: Color(0xFFE8869A)),
    AccentPreset(
        key: 'teal', light: Color(0xFF14555C), dark: Color(0xFF6FD1DA)),
    AccentPreset(
        key: 'orange', light: Color(0xFF7A4A12), dark: Color(0xFFE8A85C)),
    AccentPreset(
        key: 'pink', light: Color(0xFF7A2E55), dark: Color(0xFFE58FBE)),
    AccentPreset(
        key: 'grey', light: Color(0xFF3A3A3A), dark: Color(0xFFB0B0B0)),
  ];

  static AccentPreset get defaultPreset => all.first;
}
