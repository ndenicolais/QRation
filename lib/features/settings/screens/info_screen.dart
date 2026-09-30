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

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.h,
              children: [
                _buildLogo(),
                _buildAppName(context),
                _buildDescription(context),
                _buildCredits(context),
                _buildVersion(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        AppLocalizations.of(context)!.info_screen_title,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 180.w,
        height: 180.h,
      ),
    );
  }

  Widget _buildAppName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_origin_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_origin_description,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_description_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_description_description,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCredits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_credits_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_a_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_a_value,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_b_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_b_value,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_c_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.info_screen_credits_c_value,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.info_screen_version_text,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          AppVersion.current,
          style: AppFonts.montserrat(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
