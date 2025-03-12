import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:provider/provider.dart';
import 'package:qration/screens/authentication/login/login_controller.dart';
import 'package:qration/screens/settings/database_screen.dart';
import 'package:qration/screens/delete_account_screen.dart';
import 'package:qration/screens/settings/info_screen.dart';
import 'package:qration/screens/settings/policy_screen.dart';
import 'package:qration/screens/settings/support_screen.dart';
import 'package:qration/theme/theme_notifier.dart';
import 'package:qration/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final LoginController loginController = Get.put(LoginController());
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool beepEnabled = false;
  bool vibrateEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            _buildGeneralSection(context, themeNotifier),
            SizedBox(height: 16.h),
            _buildScanSection(context),
            SizedBox(height: 16.h),
            _buildAccountSection(context),
            SizedBox(height: 16.h),
            _buildAppSection(context),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference().then((languageCode) {
      if (mounted) {
        setState(() {});
      }
    });
    _loadPreferences();
  }

  Future<String> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ?? '';
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      beepEnabled = prefs.getBool('beepEnabled') ?? false;
      vibrateEnabled = prefs.getBool('vibrateEnabled') ?? false;
    });
  }

  Future<void> _setBeepPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      beepEnabled = value;
    });
    await prefs.setBool('beepEnabled', value);
  }

  Future<void> _setVibratePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      vibrateEnabled = value;
    });
    await prefs.setBool('vibrateEnabled', value);
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    setState(() {});
    Get.updateLocale(Locale(languageCode));
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isLanguageSwitch,
    required dynamic value,
    required ValueChanged<dynamic> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(top: 4.r),
              child: Text(
                subtitle,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      trailing: Switch(
        value: isLanguageSwitch ? (value == 'it') : value,
        onChanged: (bool newValue) {
          if (isLanguageSwitch) {
            onChanged(newValue ? 'it' : 'en');
          } else {
            onChanged(newValue);
          }
        },
        activeColor: Theme.of(context).colorScheme.tertiary,
        activeTrackColor: Theme.of(context).colorScheme.secondary,
        inactiveThumbColor: Theme.of(context).colorScheme.secondary,
        inactiveTrackColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildGeneralSection(
    BuildContext context,
    ThemeNotifier themeNotifier,
  ) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_general,
      children: [
        _buildSwitchTile(
          icon: MingCuteIcons.mgc_palette_fill,
          title: AppLocalizations.of(context)!.settings_title_theme,
          subtitle: Theme.of(context).brightness == Brightness.dark
              ? AppLocalizations.of(context)!
                  .settings_subtitle_theme_option_dark
              : AppLocalizations.of(context)!
                  .settings_subtitle_theme_option_light,
          isLanguageSwitch: false,
          value: Provider.of<ThemeNotifier>(context).isDarkMode,
          onChanged: (dynamic newValue) {
            Provider.of<ThemeNotifier>(context, listen: false).switchTheme();
          },
        ),
        _buildSwitchTile(
          icon: MingCuteIcons.mgc_world_2_fill,
          title: AppLocalizations.of(context)!.settings_title_language,
          subtitle: Get.locale?.languageCode == 'en'
              ? AppLocalizations.of(context)!
                  .settings_subtitle_language_option_english
              : AppLocalizations.of(context)!
                  .settings_subtitle_language_option_italian,
          isLanguageSwitch: true,
          value: Get.locale?.languageCode ?? 'en',
          onChanged: (dynamic newValue) {
            _saveLanguagePreference(newValue);
            Get.updateLocale(Locale(newValue));
          },
        ),
      ],
    );
  }

  Widget _buildScanSection(BuildContext context) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_scan,
      children: [
        _buildSwitchTile(
          icon: MingCuteIcons.mgc_volume_fill,
          title: AppLocalizations.of(context)!.settings_title_beep,
          subtitle: AppLocalizations.of(context)!.settings_subtile_beep,
          isLanguageSwitch: false,
          value: beepEnabled,
          onChanged: (value) {
            _setBeepPreference(value);
          },
        ),
        _buildSwitchTile(
          icon: MingCuteIcons.mgc_cellphone_vibration_fill,
          title: AppLocalizations.of(context)!.settings_title_vibrate,
          subtitle: AppLocalizations.of(context)!.settings_subtile_vibrate,
          isLanguageSwitch: false,
          value: vibrateEnabled,
          onChanged: (value) {
            _setVibratePreference(value);
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_account,
      children: [
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_storage_fill,
          title: AppLocalizations.of(context)!.settings_tile_database,
          onTap: () {
            Get.to(
              () => DatabaseScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_exit_fill,
          title: AppLocalizations.of(context)!.settings_tile_log_out,
          onTap: () {
            loginController.logout(context);
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_delete_fill,
          title: AppLocalizations.of(context)!.settings_tile_delete_account,
          onTap: () {
            Get.to(
              () => const DeleteAccountScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_app,
      children: [
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_information_fill,
          title: AppLocalizations.of(context)!.settings_tile_info,
          onTap: () {
            Get.to(
              () => const InfoScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_safe_lock_fill,
          title: AppLocalizations.of(context)!.settings_tile_privacy_policy,
          onTap: () {
            Get.to(
              () => PolicyScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_lifebuoy_fill,
          title: AppLocalizations.of(context)!.settings_tile_support,
          onTap: () {
            Get.to(
              () => const SupportScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 500),
            );
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_share_2_fill,
          title: AppLocalizations.of(context)!.settings_tile_share,
          onTap: () {
            Share.share(AppConstants.uriGithubLink.toString());
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1.w,
            ),
          ),
          margin: EdgeInsets.only(top: 8.r),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: Icon(
        MingCuteIcons.mgc_right_fill,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: onTap,
    );
  }
}
