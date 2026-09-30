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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/utils/custom_icons.dart';
import 'package:qration/features/onboarding/models/onboarding_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  List<OnboardingInfo> _buildItems(AppLocalizations l10n) => [
        OnboardingInfo(
          backgroundColor: AppColors.surfaceLight,
          title: l10n.onboarding_first_title,
          titleColor: AppColors.qrBlue,
          icon: CustomIcons.onboardingCreate,
          iconColor: AppColors.qrGold,
          description: l10n.onboarding_first_description,
          descriptionColor: AppColors.qrBlue,
        ),
        OnboardingInfo(
          backgroundColor: AppColors.qrBlue,
          title: l10n.onboarding_second_title,
          titleColor: AppColors.qrGold,
          icon: CustomIcons.onboardingScan,
          iconColor: AppColors.qrWhite,
          description: l10n.onboarding_second_description,
          descriptionColor: AppColors.qrGold,
        ),
        OnboardingInfo(
          backgroundColor: AppColors.qrGold,
          title: l10n.onboarding_third_title,
          titleColor: AppColors.qrWhite,
          icon: CustomIcons.onboardingSave,
          iconColor: AppColors.qrBlueDark,
          description: l10n.onboarding_third_description,
          descriptionColor: AppColors.qrWhite,
        ),
      ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Get.offAllNamed(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _buildItems(l10n);
    final isLast = _currentPage == items.length - 1;
    final bg = items[_currentPage].backgroundColor;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardingPage(item: items[i]),
              ),
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: isLast
                    ? _FinishButton(onTap: _finish, item: items.last)
                    : _NavRow(
                        controller: _controller,
                        items: items,
                        currentPage: _currentPage,
                        bg: bg,
                        onSkip: _finish,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingInfo item;
  const _OnboardingPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 72, color: item.iconColor),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: item.titleColor,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 20),
          Text(
            item.description,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: item.descriptionColor,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final PageController controller;
  final List<OnboardingInfo> items;
  final int currentPage;
  final Color bg;
  final VoidCallback onSkip;

  const _NavRow({
    required this.controller,
    required this.items,
    required this.currentPage,
    required this.bg,
    required this.onSkip,
  });

  Color get _indicatorColor => items[currentPage].iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onSkip,
          child: Text('Skip',
              style: TextStyle(
                color: items[currentPage].descriptionColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              )),
        ),
        AnimatedSmoothIndicator(
          activeIndex: currentPage,
          count: items.length,
          effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: _indicatorColor,
            dotColor: _indicatorColor.withValues(alpha: 0.3),
          ),
        ),
        GestureDetector(
          onTap: () => controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _indicatorColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              MingCuteIcons.mgc_arrow_right_fill,
              color: items[currentPage].backgroundColor,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _FinishButton extends StatelessWidget {
  final VoidCallback onTap;
  final OnboardingInfo item;
  const _FinishButton({required this.onTap, required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          decoration: BoxDecoration(
            color: item.iconColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            AppLocalizations.of(context)!.onboarding_get_started,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: item.backgroundColor,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}
