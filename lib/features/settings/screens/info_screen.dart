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
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/constants/app_version.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/widgets/section_card.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // Colors and title style come from the theme appBarTheme.
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
          onPressed: Get.back,
        ),
        title: Text(l10n.info_screen_title),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20.h,
            children: [
              const _AppHeader(),
              SectionCard(
                title: l10n.info_screen_origin_text,
                icon: MingCuteIcons.mgc_bulb_fill,
                child: _Paragraph(l10n.info_screen_origin_description),
              ),
              SectionCard(
                title: l10n.info_screen_description_text,
                icon: MingCuteIcons.mgc_information_fill,
                child: _Paragraph(l10n.info_screen_description_description),
              ),
              SectionCard(
                title: l10n.info_screen_credits_text,
                icon: MingCuteIcons.mgc_user_3_fill,
                child: Column(
                  children: [
                    _CreditRow(
                      label: l10n.info_screen_credits_a_text,
                      value: l10n.info_screen_credits_a_value,
                    ),
                    Divider(height: 20.h),
                    _CreditRow(
                      label: l10n.info_screen_credits_b_text,
                      value: l10n.info_screen_credits_b_value,
                    ),
                    Divider(height: 20.h),
                    _CreditRow(
                      label: l10n.info_screen_credits_c_text,
                      value: l10n.info_screen_credits_c_value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo, app name and version pill.
class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Image.asset('assets/images/app_logo.png', width: 120.w, height: 120.w),
        SizedBox(height: 12.h),
        Text(
          'QRation',
          style: AppFonts.montserrat(
            color: colorScheme.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            '${l10n.info_screen_version_text} ${AppVersion.current}',
            style: AppFonts.montserrat(
              color: colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.montserrat(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 14.sp,
        height: 1.5,
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  const _CreditRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppFonts.montserrat(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13.sp,
            ),
          ),
        ),
        Text(
          value,
          style: AppFonts.montserrat(
            color: colorScheme.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
