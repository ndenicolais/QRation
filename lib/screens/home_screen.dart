import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/screens/codes/code_create_types_screen.dart';
import 'package:qration/screens/codes/code_scanner_screen.dart';
import 'package:qration/screens/user/user_controller.dart';
import 'package:qration/screens/favorites_screen.dart';
import 'package:qration/screens/history_screen.dart';
import 'package:qration/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.put(UserController());
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildBody(),
                const FavoritesScreen(),
                const HistoryScreen(),
                const SettingsScreen()
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userController.loadUserName();
  }

  @override
  void dispose() {
    Get.delete<UserController>();
    super.dispose();
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            _buildGreeting(context),
            SizedBox(height: 40.h),
            _buildTabs(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.home_screen_welcome_text,
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 40.sp,
          ),
        ),
        Obx(
          () => Text(
            userController.userName.value,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Center(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QRCard(
                    title: AppLocalizations.of(context)!.home_qr_cards_create,
                    bgColor: Theme.of(context).colorScheme.secondary,
                    icon: MingCuteIcons.mgc_qrcode_fill,
                    iconColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.to(
                        () => CodeCreateTypesScreen(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  QRCard(
                    title: AppLocalizations.of(context)!.home_qr_cards_scan,
                    bgColor: Theme.of(context).colorScheme.secondary,
                    icon: MingCuteIcons.mgc_scan_fill,
                    iconColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Get.to(
                        () => const ScannerScreen(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavItem(
          context: context,
          icon: MingCuteIcons.mgc_home_2_line,
          label: AppLocalizations.of(context)!.bottom_nav_item_home,
        ),
        BottomNavItem(
          context: context,
          icon: MingCuteIcons.mgc_heart_line,
          label: AppLocalizations.of(context)!.bottom_nav_item_favorites,
        ),
        BottomNavItem(
          context: context,
          icon: MingCuteIcons.mgc_history_line,
          label: AppLocalizations.of(context)!.bottom_nav_item_history,
        ),
        BottomNavItem(
          context: context,
          icon: MingCuteIcons.mgc_settings_5_line,
          label: AppLocalizations.of(context)!.bottom_nav_item_settings,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTap,
    );
  }
}

class BottomNavItem extends BottomNavigationBarItem {
  BottomNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) : super(
            icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
            activeIcon:
                Icon(icon, color: Theme.of(context).colorScheme.primary),
            label: label,
            backgroundColor: Theme.of(context).colorScheme.secondary);
}

class QRCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const QRCard({
    super.key,
    required this.title,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: bgColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: SizedBox(
          width: screenWidth > 600 ? 340.w : 220.w,
          height: screenHeight > 1000 ? 340.h : 220.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 120.sp,
                color: iconColor,
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
