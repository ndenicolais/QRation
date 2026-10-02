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
import 'package:qration/app.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/accent_presets.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/settings/controllers/settings_controller.dart';
import 'package:qration/features/settings/widgets/settings_tiles.dart';
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
  final _settingsCtrl = Get.find<SettingsController>();
  final _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildGeneralSection(context),
            SizedBox(height: 16),
            _buildScanSection(context),
            SizedBox(height: 16),
            _buildAccountSection(context),
            SizedBox(height: 16),
            _buildAppSection(context),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(QrationApp.languageKey, languageCode);
    if (mounted) setState(() {});
    Get.updateLocale(Locale(languageCode));
  }

  Widget _buildGeneralSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return SettingsGroup(
      title: l10n.settings_title_general,
      children: [
        Obx(() => SettingsSegmentedTile<ThemeMode>(
              icon: MingCuteIcons.mgc_palette_fill,
              title: l10n.settings_title_theme,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(MingCuteIcons.mgc_cellphone_fill, size: 16),
                  label: Text(l10n.settings_subtitle_theme_option_system),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(MingCuteIcons.mgc_sun_fill, size: 16),
                  label: Text(l10n.settings_subtitle_theme_option_light),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(MingCuteIcons.mgc_moon_fill, size: 16),
                  label: Text(l10n.settings_subtitle_theme_option_dark),
                ),
              ],
              selected: _settingsCtrl.themeMode,
              onChanged: _settingsCtrl.setThemeMode,
            )),
        SettingsSegmentedTile<String>(
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
          // Without a saved preference Get.locale is null: show the language
          // the app is actually using.
          selected: Localizations.localeOf(context).languageCode == 'it'
              ? 'it'
              : 'en',
          onChanged: _saveLanguagePreference,
        ),
        Obx(() => SettingsSegmentedTile<int>(
              icon: MingCuteIcons.mgc_palette_2_fill,
              title: l10n.settings_title_accent_color,
              segments: List.generate(AccentPresets.all.length, (index) {
                final preset = AccentPresets.all[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final isSelected = _settingsCtrl.accentIndex == index;
                return ButtonSegment(
                  value: index,
                  icon: Tooltip(
                    message: _accentPresetName(l10n, preset.key),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isDark ? preset.dark : preset.light,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: colorScheme.onSurface, width: 2)
                            : null,
                      ),
                    ),
                  ),
                );
              }),
              selected: _settingsCtrl.accentIndex,
              onChanged: _settingsCtrl.setAccent,
              selectedBackgroundColor: colorScheme.surfaceContainerHighest,
            )),
      ],
    );
  }

  String _accentPresetName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'green':
        return l10n.settings_accent_color_green;
      case 'purple':
        return l10n.settings_accent_color_purple;
      case 'red':
        return l10n.settings_accent_color_red;
      case 'teal':
        return l10n.settings_accent_color_teal;
      case 'orange':
        return l10n.settings_accent_color_orange;
      case 'pink':
        return l10n.settings_accent_color_pink;
      case 'grey':
        return l10n.settings_accent_color_grey;
      case 'blue':
      default:
        return l10n.settings_accent_color_blue;
    }
  }

  Widget _buildScanSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingsGroup(
      title: l10n.settings_title_scan,
      children: [
        Obx(() => SettingsSwitchTile(
              icon: MingCuteIcons.mgc_volume_fill,
              title: l10n.settings_title_beep,
              subtitle: l10n.settings_subtile_beep,
              value: _settingsCtrl.beepEnabled,
              onChanged: _settingsCtrl.toggleBeep,
            )),
        Obx(() => SettingsSwitchTile(
              icon: MingCuteIcons.mgc_cellphone_vibration_fill,
              title: l10n.settings_title_vibrate,
              subtitle: l10n.settings_subtile_vibrate,
              value: _settingsCtrl.vibrateEnabled,
              onChanged: _settingsCtrl.toggleVibrate,
            )),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingsGroup(
      title: l10n.settings_title_account,
      children: [
        SettingsNavTile(
          icon: MingCuteIcons.mgc_user_3_fill,
          title: l10n.settings_tile_profile,
          onTap: () => Get.toNamed(AppRoutes.user),
        ),
        SettingsNavTile(
          icon: MingCuteIcons.mgc_storage_fill,
          title: l10n.settings_tile_database,
          onTap: () => Get.toNamed(AppRoutes.settingsDatabase),
        ),
        SettingsNavTile(
          icon: MingCuteIcons.mgc_exit_fill,
          title: l10n.settings_tile_log_out,
          onTap: _authCtrl.logout,
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingsGroup(
      title: l10n.settings_title_app,
      children: [
        SettingsNavTile(
          icon: MingCuteIcons.mgc_information_fill,
          title: l10n.settings_tile_info,
          onTap: () => Get.toNamed(AppRoutes.settingsInfo),
        ),
        SettingsNavTile(
          icon: MingCuteIcons.mgc_sparkles_fill,
          title: l10n.settings_tile_changelog,
          onTap: () => AppChangelogDialog.showAll(context),
        ),
        SettingsNavTile(
          icon: MingCuteIcons.mgc_lifebuoy_fill,
          title: l10n.settings_tile_support,
          onTap: () => Get.toNamed(AppRoutes.settingsSupport),
        ),
        SettingsNavTile(
          icon: MingCuteIcons.mgc_share_2_fill,
          title: l10n.settings_tile_share,
          onTap: () => Share.share(AppConstants.uriGithubRepository.toString()),
        ),
      ],
    );
  }
}
