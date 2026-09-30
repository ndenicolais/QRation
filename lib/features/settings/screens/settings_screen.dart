// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/accent_presets.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/settings/controllers/settings_controller.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/widgets/app_changelog_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _settingsCtrl = Get.put(SettingsController());
  final _authCtrl = Get.find<AuthController>();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            _buildGeneralSection(context),
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
  }

  Future<String> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ?? '';
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
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: EdgeInsets.only(top: 4.r),
              child: Text(
                subtitle,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.tertiary,
        activeTrackColor: Theme.of(context).colorScheme.secondary,
        inactiveThumbColor: Theme.of(context).colorScheme.secondary,
        inactiveTrackColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSegmentedTile<T>({
    required IconData icon,
    required String title,
    required List<ButtonSegment<T>> segments,
    required Set<T> selected,
    required ValueChanged<T> onChanged,
    Color? selectedBackgroundColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: Theme.of(context).colorScheme.primary, size: 20.r),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<T>(
              segments: segments,
              selected: selected,
              showSelectedIcon: false,
              onSelectionChanged: (newSelection) =>
                  onChanged(newSelection.first),
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                selectedBackgroundColor: selectedBackgroundColor ??
                    Theme.of(context).colorScheme.primary,
                selectedForegroundColor:
                    Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _buildSettingsSection(
      title: l10n.settings_title_general,
      children: [
        Obx(() => _buildSegmentedTile<ThemeMode>(
              icon: MingCuteIcons.mgc_palette_fill,
              title: l10n.settings_title_theme,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(MingCuteIcons.mgc_cellphone_fill, size: 16.r),
                  label: Text(l10n.settings_subtitle_theme_option_system),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(MingCuteIcons.mgc_sun_fill, size: 16.r),
                  label: Text(l10n.settings_subtitle_theme_option_light),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(MingCuteIcons.mgc_moon_fill, size: 16.r),
                  label: Text(l10n.settings_subtitle_theme_option_dark),
                ),
              ],
              selected: {_settingsCtrl.themeMode},
              onChanged: (value) => _settingsCtrl.setThemeMode(value),
            )),
        _buildSegmentedTile<String>(
          icon: MingCuteIcons.mgc_world_2_fill,
          title: l10n.settings_title_language,
          segments: [
            ButtonSegment(
              value: 'it',
              label: Text(l10n.settings_subtitle_language_option_italian),
            ),
            ButtonSegment(
              value: 'en',
              label: Text(l10n.settings_subtitle_language_option_english),
            ),
          ],
          selected: {Get.locale?.languageCode == 'it' ? 'it' : 'en'},
          onChanged: (value) {
            _saveLanguagePreference(value);
            Get.updateLocale(Locale(value));
          },
        ),
        Obx(() => _buildSegmentedTile<int>(
              icon: MingCuteIcons.mgc_palette_2_fill,
              title: l10n.settings_title_accent_color,
              segments: List.generate(AccentPresets.all.length, (index) {
                final preset = AccentPresets.all[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final swatchColor = isDark ? preset.dark : preset.light;
                final isSelected = _settingsCtrl.accentIndex == index;
                return ButtonSegment(
                  value: index,
                  icon: Tooltip(
                    message: _accentPresetName(context, preset.key),
                    child: Container(
                      width: 20.r,
                      height: 20.r,
                      decoration: BoxDecoration(
                        color: swatchColor,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              }),
              selected: {_settingsCtrl.accentIndex},
              onChanged: (value) => _settingsCtrl.setAccent(value),
              selectedBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            )),
      ],
    );
  }

  String _accentPresetName(BuildContext context, String key) {
    switch (key) {
      case 'green':
        return AppLocalizations.of(context)!.settings_accent_color_green;
      case 'purple':
        return AppLocalizations.of(context)!.settings_accent_color_purple;
      case 'red':
        return AppLocalizations.of(context)!.settings_accent_color_red;
      case 'teal':
        return AppLocalizations.of(context)!.settings_accent_color_teal;
      case 'orange':
        return AppLocalizations.of(context)!.settings_accent_color_orange;
      case 'pink':
        return AppLocalizations.of(context)!.settings_accent_color_pink;
      case 'grey':
        return AppLocalizations.of(context)!.settings_accent_color_grey;
      case 'blue':
      default:
        return AppLocalizations.of(context)!.settings_accent_color_blue;
    }
  }

  Widget _buildScanSection(BuildContext context) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_scan,
      children: [
        Obx(() => _buildSwitchTile(
              icon: MingCuteIcons.mgc_volume_fill,
              title: AppLocalizations.of(context)!.settings_title_beep,
              subtitle: AppLocalizations.of(context)!.settings_subtile_beep,
              value: _settingsCtrl.beepEnabled,
              onChanged: (value) {
                _settingsCtrl.toggleBeep(value);
              },
            )),
        Obx(() => _buildSwitchTile(
              icon: MingCuteIcons.mgc_cellphone_vibration_fill,
              title: AppLocalizations.of(context)!.settings_title_vibrate,
              subtitle: AppLocalizations.of(context)!.settings_subtile_vibrate,
              value: _settingsCtrl.vibrateEnabled,
              onChanged: (value) {
                _settingsCtrl.toggleVibrate(value);
              },
            )),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSettingsSection(
      title: AppLocalizations.of(context)!.settings_title_account,
      children: [
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_user_3_fill,
          title: AppLocalizations.of(context)!.settings_tile_profile,
          onTap: () {
            Get.toNamed(AppRoutes.user);
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_storage_fill,
          title: AppLocalizations.of(context)!.settings_tile_database,
          onTap: () {
            Get.toNamed(AppRoutes.settingsDatabase);
          },
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_exit_fill,
          title: AppLocalizations.of(context)!.settings_tile_log_out,
          onTap: () {
            _authCtrl.logout();
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
          onTap: () => Get.toNamed(AppRoutes.settingsInfo),
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_sparkles_fill,
          title: AppLocalizations.of(context)!.settings_tile_changelog,
          onTap: () => AppChangelogDialog.showAll(context),
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_safe_lock_fill,
          title: AppLocalizations.of(context)!.settings_tile_privacy_policy,
          onTap: () => Get.toNamed(AppRoutes.settingsPolicy),
        ),
        _buildSettingsTile(
          icon: MingCuteIcons.mgc_lifebuoy_fill,
          title: AppLocalizations.of(context)!.settings_tile_support,
          onTap: () => Get.toNamed(AppRoutes.settingsSupport),
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
          style: AppFonts.montserrat(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Card(
          color: Theme.of(context).cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
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
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppFonts.montserrat(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: Icon(
        MingCuteIcons.mgc_right_fill,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
