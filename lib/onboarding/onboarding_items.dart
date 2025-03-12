import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qration/onboarding/onboarding_info.dart';
import 'package:qration/theme/app_colors.dart';
import 'package:qration/utils/custom_icons.dart';

class OnboardingItems {
  final BuildContext context;
  late final List<OnboardingInfo> items;

  OnboardingItems(this.context) {
    items = [
      OnboardingInfo(
        backgroundColor: AppColors.qrWhite,
        title: AppLocalizations.of(context)!.onboarding_first_title,
        titleColor: AppColors.qrBlue,
        icon: CustomIcons.onboardingCreate,
        iconColor: AppColors.qrGold,
        description: AppLocalizations.of(context)!.onboarding_first_description,
        descriptionColor: AppColors.qrBlue,
      ),
      OnboardingInfo(
        backgroundColor: AppColors.qrBlue,
        title: AppLocalizations.of(context)!.onboarding_second_title,
        titleColor: AppColors.qrGold,
        icon: CustomIcons.onboardingScan,
        iconColor: AppColors.qrWhite,
        description:
            AppLocalizations.of(context)!.onboarding_second_description,
        descriptionColor: AppColors.qrGold,
      ),
      OnboardingInfo(
        backgroundColor: AppColors.qrGold,
        title: AppLocalizations.of(context)!.onboarding_third_title,
        titleColor: AppColors.qrWhite,
        icon: CustomIcons.onboardingSave,
        iconColor: AppColors.qrBlue,
        description: AppLocalizations.of(context)!.onboarding_third_description,
        descriptionColor: AppColors.qrWhite,
      ),
    ];
  }
}
