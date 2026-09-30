// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';

class QrStyleCustomizer extends StatelessWidget {
  const QrStyleCustomizer({super.key, required this.controller});

  final CodeCreateStandardController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  l10n.code_create_standard_screen_eye_title,
                  style: AppFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                _CustomizationRow(
                  colorLabel: l10n.code_create_standard_screen_eye_color,
                  roundedLabel: l10n.code_create_standard_screen_eye_rounded,
                  color: controller.eyeColor,
                  rounded: controller.eyeRounded,
                  onPickColor: () => _pickColor(context, controller.eyeColor),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  l10n.code_create_standard_screen_module_title,
                  style: AppFonts.montserrat(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                _CustomizationRow(
                  colorLabel: l10n.code_create_standard_screen_module_color,
                  roundedLabel: l10n.code_create_standard_screen_module_rounded,
                  color: controller.moduleColor,
                  rounded: controller.moduleRounded,
                  onPickColor: () =>
                      _pickColor(context, controller.moduleColor),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          l10n.code_create_standard_screen_logo_title,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: controller.pickLogo,
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                    image: controller.logoPath.value != null
                        ? DecorationImage(
                            image: FileImage(File(controller.logoPath.value!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.logoPath.value == null
                      ? Icon(Icons.add_photo_alternate_outlined,
                          color: Theme.of(context).colorScheme.secondary)
                      : null,
                ),
              ),
              if (controller.logoPath.value != null)
                IconButton(
                  onPressed: controller.removeLogo,
                  icon: Icon(Icons.close,
                      color: Theme.of(context).colorScheme.secondary),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _pickColor(BuildContext context, Rx<Color> target) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          l10n.code_create_standard_screen_dialog_color_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
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
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              l10n.code_create_standard_screen_dialog_color_select,
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
}

class _CustomizationRow extends StatelessWidget {
  const _CustomizationRow({
    required this.colorLabel,
    required this.roundedLabel,
    required this.color,
    required this.rounded,
    required this.onPickColor,
  });

  final String colorLabel;
  final String roundedLabel;
  final Rx<Color> color;
  final RxInt rounded;
  final VoidCallback onPickColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          colorLabel,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: onPickColor,
          child: Obx(
            () => Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color.value,
                borderRadius: BorderRadius.circular(15.r),
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          roundedLabel,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Obx(
          () => Switch(
            value: rounded.value == 1,
            onChanged: (value) => rounded.value = value ? 1 : 0,
            activeColor: Theme.of(context).colorScheme.tertiary,
            activeTrackColor: Theme.of(context).colorScheme.secondary,
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
