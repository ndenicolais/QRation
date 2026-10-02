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
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/features/codes/controllers/qr_style_mixin.dart';

/// Eye/module color and rounding plus optional center logo, shared by the
/// standard and social creation screens.
class QrStyleCustomizer extends StatelessWidget {
  const QrStyleCustomizer({super.key, required this.style});

  final QrStyleMixin style;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      title: l10n.code_create_style_title,
      icon: MingCuteIcons.mgc_palette_fill,
      child: Column(
        children: [
          _StyleRow(
            title: l10n.code_create_standard_screen_eye_title,
            colorLabel: l10n.code_create_standard_screen_eye_color,
            roundedLabel: l10n.code_create_standard_screen_eye_rounded,
            color: style.eyeColor,
            rounded: style.eyeRounded,
            onPickColor: () => _pickColor(context, style.eyeColor),
          ),
          Divider(height: 24),
          _StyleRow(
            title: l10n.code_create_standard_screen_module_title,
            colorLabel: l10n.code_create_standard_screen_module_color,
            roundedLabel: l10n.code_create_standard_screen_module_rounded,
            color: style.moduleColor,
            rounded: style.moduleRounded,
            onPickColor: () => _pickColor(context, style.moduleColor),
          ),
          Divider(height: 24),
          _LogoRow(
              style: style, title: l10n.code_create_standard_screen_logo_title),
        ],
      ),
    );
  }

  void _pickColor(BuildContext context, Rx<Color> target) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.code_create_standard_screen_dialog_color_text),
        content: SingleChildScrollView(
          child: Obx(
            () => ColorPicker(
              pickerColor: target.value,
              onColorChanged: (newColor) => target.value = newColor,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(l10n.code_create_standard_screen_dialog_color_select),
          ),
        ],
      ),
    );
  }
}

class _StyleRow extends StatelessWidget {
  const _StyleRow({
    required this.title,
    required this.colorLabel,
    required this.roundedLabel,
    required this.color,
    required this.rounded,
    required this.onPickColor,
  });

  final String title;
  final String colorLabel;
  final String roundedLabel;
  final Rx<Color> color;
  final RxInt rounded;
  final VoidCallback onPickColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppFonts.montserrat(
              color: colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tooltip(
          message: colorLabel,
          child: InkWell(
            onTap: onPickColor,
            customBorder: const CircleBorder(),
            child: Obx(
              () => Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.value,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.outline, width: 2),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Text(
          roundedLabel,
          style: AppFonts.montserrat(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        SizedBox(width: 4),
        // Colors come from the theme switchTheme (neutral track when off).
        Obx(
          () => Switch(
            value: rounded.value == 1,
            onChanged: (value) => rounded.value = value ? 1 : 0,
          ),
        ),
      ],
    );
  }
}

class _LogoRow extends StatelessWidget {
  const _LogoRow({required this.style, required this.title});

  final QrStyleMixin style;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppFonts.montserrat(
              color: colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Obx(() {
          final logoPath = style.logoPath.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logoPath != null)
                IconButton(
                  tooltip:
                      MaterialLocalizations.of(context).deleteButtonTooltip,
                  onPressed: style.removeLogo,
                  icon: Icon(
                    MingCuteIcons.mgc_close_line,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              InkWell(
                onTap: style.pickLogo,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: colorScheme.outline, width: 2),
                    image: logoPath != null
                        ? DecorationImage(
                            image: FileImage(File(logoPath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: logoPath == null
                      ? Icon(
                          MingCuteIcons.mgc_pic_line,
                          color: colorScheme.primary,
                        )
                      : null,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
