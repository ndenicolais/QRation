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
import 'package:qration/core/widgets/app_logo.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/constants/app_version.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/features/settings/widgets/settings_tiles.dart';
import 'package:url_launcher/url_launcher.dart';

/// About the app: identity, what it does, useful links and credits.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
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
          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              const _AppHeader(),
              SectionCard(
                title: l10n.info_screen_about_title,
                icon: MingCuteIcons.mgc_information_fill,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      l10n.info_screen_about_text,
                      style: AppFonts.montserrat(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      l10n.info_screen_origin_description,
                      style: AppFonts.montserrat(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    title: l10n.info_screen_features_title,
                    icon: MingCuteIcons.mgc_sparkles_fill,
                  ),
                  const _FeatureGrid(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    title: l10n.info_screen_links_title,
                    icon: MingCuteIcons.mgc_link_fill,
                  ),
                  const _LinksCard(),
                ],
              ),
              Text(
                l10n.info_screen_made_by(AppConstants.developerName),
                textAlign: TextAlign.center,
                style: AppFonts.montserrat(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo, app name, tagline and version pill.
class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        AppLogo(size: 120),
        SizedBox(height: 12),
        Text(
          'QRation',
          style: AppFonts.montserrat(
            color: colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          l10n.info_screen_tagline,
          textAlign: TextAlign.center,
          style: AppFonts.montserrat(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            '${l10n.info_screen_version_text} ${AppVersion.current}',
            style: AppFonts.montserrat(
              color: colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Two-by-two grid of the main features.
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = [
      (
        MingCuteIcons.mgc_scan_fill,
        l10n.info_screen_feature_scan_title,
        l10n.info_screen_feature_scan_text,
      ),
      (
        MingCuteIcons.mgc_qrcode_2_fill,
        l10n.info_screen_feature_create_title,
        l10n.info_screen_feature_create_text,
      ),
      (
        MingCuteIcons.mgc_star_fill,
        l10n.info_screen_feature_library_title,
        l10n.info_screen_feature_library_text,
      ),
      (
        MingCuteIcons.mgc_file_export_fill,
        l10n.info_screen_feature_export_title,
        l10n.info_screen_feature_export_text,
      ),
    ];

    return Column(
      spacing: 12,
      children: [
        for (var i = 0; i < features.length; i += 2)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Expanded(child: _FeatureCard(feature: features[i])),
                Expanded(child: _FeatureCard(feature: features[i + 1])),
              ],
            ),
          ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final (IconData, String, String) feature;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, title, text) = feature;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(icon, size: 20, color: colorScheme.primary),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: AppFonts.montserrat(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              text,
              style: AppFonts.montserrat(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Source code, website, contact, privacy policy and open source licenses.
class _LinksCard extends StatelessWidget {
  const _LinksCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = [
      SettingsNavTile(
        icon: MingCuteIcons.mgc_github_fill,
        title: l10n.info_screen_link_source,
        trailingIcon: MingCuteIcons.mgc_external_link_line,
        onTap: () => _open(AppConstants.uriGithubDocumentation),
      ),
      SettingsNavTile(
        icon: MingCuteIcons.mgc_world_2_fill,
        title: l10n.info_screen_link_website,
        trailingIcon: MingCuteIcons.mgc_external_link_line,
        onTap: () => _open(AppConstants.uriGithubLink),
      ),
      SettingsNavTile(
        icon: MingCuteIcons.mgc_mail_fill,
        title: l10n.info_screen_link_contact,
        trailingIcon: MingCuteIcons.mgc_external_link_line,
        onTap: () => launchUrl(AppConstants.uriMail),
      ),
      SettingsNavTile(
        icon: MingCuteIcons.mgc_safe_lock_fill,
        title: l10n.policy_screen_title,
        onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
      ),
      SettingsNavTile(
        icon: MingCuteIcons.mgc_document_2_fill,
        title: l10n.info_screen_link_licenses,
        onTap: () => showLicensePage(
          context: context,
          applicationName: 'QRation',
          applicationVersion: AppVersion.current,
          applicationIcon: Padding(
            padding: EdgeInsets.all(8),
            child: AppLogo(size: 64),
          ),
        ),
      ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 56),
            rows[i],
          ],
        ],
      ),
    );
  }

  Future<void> _open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
