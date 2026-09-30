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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/theme/app_font_sizes.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:screenshot/screenshot.dart';

class CodeInfoRow extends StatelessWidget {
  const CodeInfoRow({
    super.key,
    required this.dateLabel,
    required this.date,
    required this.typeLabel,
    required this.typeIcon,
    required this.typeContent,
    this.typeIconHeroTag,
  });

  final String dateLabel;
  final String date;
  final String typeLabel;
  final IconData? typeIcon;
  final String typeContent;

  /// When set, the type icon flies in from the list card it was opened from.
  final String? typeIconHeroTag;

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } catch (e) {
      parsedDate = null;
    }
    final formattedDate = parsedDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(parsedDate)
        : date;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoChip(label: dateLabel, value: formattedDate),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _InfoChip(
            label: typeLabel,
            value: typeContent,
            icon: typeIcon,
            iconHeroTag: typeIconHeroTag,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    this.icon,
    this.iconHeroTag,
  });

  final String label;
  final String value;
  final IconData? icon;
  final String? iconHeroTag;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.montserrat(
              color: secondary.withValues(alpha: 0.6),
              fontSize: AppFontSizes.extraSmall,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (icon != null) ...[
                if (iconHeroTag != null)
                  Hero(
                    tag: iconHeroTag!,
                    child: Icon(icon, size: 16.sp, color: secondary),
                  )
                else
                  Icon(icon, size: 16.sp, color: secondary),
                SizedBox(width: 6.w),
              ],
              Expanded(
                child: Text(
                  value,
                  style: AppFonts.montserrat(
                    color: secondary,
                    fontSize: AppFontSizes.small,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CodeQrSection extends StatelessWidget {
  const CodeQrSection({
    super.key,
    required this.title,
    required this.code,
    required this.screenshotController,
  });

  final String title;
  final CodeModel code;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: AppFontSizes.mediumLarge,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: SizedBox(
            width: 220.w,
            height: 220.h,
            child: Screenshot(
              controller: screenshotController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220.sp,
                    height: 220.sp,
                    child: PrettyQrView.data(
                      data: code.barcode.rawValue ?? '',
                      errorCorrectLevel: code.logoPath != null
                          ? QrErrorCorrectLevel.H
                          : QrErrorCorrectLevel.M,
                      decoration: buildQrDecoration(
                        eyeColor: code.eyeColor,
                        eyeRounded: code.eyeRounded,
                        moduleColor: code.moduleColor,
                        moduleRounded: code.moduleRounded,
                        logoImage: code.logoPath != null
                            ? FileImage(File(code.logoPath!))
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
