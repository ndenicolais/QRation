import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qration/onboarding/onboarding_info.dart';
import 'package:qration/onboarding/onboarding_items.dart';
import 'package:qration/screens/home_screen.dart';
import 'package:qration/screens/welcome_screen.dart';
import 'package:qration/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late OnboardingItems onboardingItems;
  int currentPage = 0;
  final int _totalPages = 3;
  bool isFirstPage = true;
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    Color currentBackgroundColor =
        onboardingItems.items[currentPage].backgroundColor;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: currentBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                onPageChanged: (index) {
                  setState(
                    () {
                      currentPage = index;
                      isFirstPage = index == 0;
                      isLastPage = onboardingItems.items.length - 1 == index;
                    },
                  );
                },
                controller: _pageController,
                itemCount: onboardingItems.items.length,
                itemBuilder: (context, index) {
                  final item = onboardingItems.items[index];
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [_buildPageContent(item)],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 30.r,
                left: 0.r,
                right: 0.r,
                child: isLastPage
                    ? Center(child: _buildEndButton())
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSkipButton(currentBackgroundColor),
                            _buildPageIndicators(currentBackgroundColor),
                            _buildNextButton(currentBackgroundColor),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingInfo item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: item.titleColor,
            fontSize: 50.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        40.verticalSpace,
        SizedBox(
          width: 180.w,
          height: 180.h,
          child: Icon(
            item.icon,
            size: 200,
            color: item.iconColor,
          ),
        ),
        60.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.r),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: item.descriptionColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators(Color backgroundColor) {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _totalPages,
      effect: WormEffect(
        dotWidth: 10.w,
        dotHeight: 10.h,
        spacing: 16.r,
        radius: 8.r,
        activeDotColor: _getIndicatorActiveColor(backgroundColor),
        dotColor: _getIndicatorDotColor(backgroundColor),
      ),
    );
  }

  Widget _buildSkipButton(Color backgroundColor) {
    return TextButton(
      onPressed: _skip,
      child: Text(
        AppLocalizations.of(context)!.onboarding_skip,
        style: GoogleFonts.montserrat(
          color: _getTextColor(backgroundColor),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNextButton(Color backgroundColor) {
    return TextButton(
      onPressed: _nextPage,
      child: Text(
        AppLocalizations.of(context)!.onboarding_next,
        style: GoogleFonts.montserrat(
          color: _getTextColor(backgroundColor),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEndButton() {
    return SizedBox(
      width: 200.w,
      height: 50.h,
      child: MaterialButton(
        onPressed: () async {
          final pres = await SharedPreferences.getInstance();
          pres.setBool("onboarding_completed", true);
          _checkRememberMe();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.onboarding_finish,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    if (backgroundColor == AppColors.qrWhite) {
      return AppColors.qrBlue;
    } else if (backgroundColor == AppColors.qrBlue) {
      return AppColors.qrWhite;
    } else {
      return AppColors.qrBlue;
    }
  }

  Color _getIndicatorActiveColor(Color backgroundColor) {
    if (backgroundColor == AppColors.qrWhite) {
      return AppColors.qrBlue;
    } else if (backgroundColor == AppColors.qrBlue) {
      return AppColors.qrGold;
    } else {
      return AppColors.qrBlue;
    }
  }

  Color _getIndicatorDotColor(Color backgroundColor) {
    if (backgroundColor == AppColors.qrWhite) {
      return AppColors.qrGold;
    } else if (backgroundColor == AppColors.qrBlue) {
      return AppColors.qrWhite;
    } else {
      return AppColors.qrBlue;
    }
  }

  void _nextPage() {
    if (_pageController.page!.toInt() < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _checkRememberMe();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onboardingItems = OnboardingItems(context);
  }

  void _skip() {
    _pageController.jumpToPage(_totalPages - 1);
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      Get.offAll(
        () => const HomeScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      Get.offAll(
        () => const WelcomeScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
