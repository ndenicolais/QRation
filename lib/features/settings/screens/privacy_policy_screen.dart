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
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Native, localized privacy policy. The same text is published in
/// PRIVACY.md and on [AppConstants.uriPrivacyPolicy]: keep them in sync.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final updated =
        DateFormat.yMMMMd(locale).format(AppConstants.privacyPolicyUpdatedAt);

    final sections = [
      (
        MingCuteIcons.mgc_user_3_fill,
        l10n.policy_section_controller_title,
        l10n.policy_section_controller_text(
          AppConstants.developerName,
          AppConstants.developerEmail,
        ),
      ),
      (
        MingCuteIcons.mgc_file_info_fill,
        l10n.policy_section_data_title,
        l10n.policy_section_data_text,
      ),
      (
        MingCuteIcons.mgc_settings_3_fill,
        l10n.policy_section_use_title,
        l10n.policy_section_use_text,
      ),
      (
        MingCuteIcons.mgc_cloud_fill,
        l10n.policy_section_storage_title,
        l10n.policy_section_storage_text,
      ),
      (
        MingCuteIcons.mgc_cellphone_fill,
        l10n.policy_section_device_title,
        l10n.policy_section_device_text,
      ),
      (
        MingCuteIcons.mgc_key_2_fill,
        l10n.policy_section_permissions_title,
        l10n.policy_section_permissions_text,
      ),
      (
        MingCuteIcons.mgc_delete_2_fill,
        l10n.policy_section_retention_title,
        l10n.policy_section_retention_text,
      ),
      (
        MingCuteIcons.mgc_shield_fill,
        l10n.policy_section_rights_title,
        l10n.policy_section_rights_text,
      ),
      (
        MingCuteIcons.mgc_user_heart_fill,
        l10n.policy_section_children_title,
        l10n.policy_section_children_text,
      ),
      (
        MingCuteIcons.mgc_refresh_2_fill,
        l10n.policy_section_changes_title,
        l10n.policy_section_changes_text,
      ),
    ];

    return Scaffold(
      // Colors and title style come from the theme appBarTheme.
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
          onPressed: Get.back,
        ),
        title: Text(l10n.policy_screen_title),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              l10n.policy_screen_updated(updated),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 8),
            _Paragraph(l10n.policy_screen_intro),
            for (final (index, (icon, title, text)) in sections.indexed) ...[
              SizedBox(height: 20),
              SectionCard(
                title: '${index + 1}. $title',
                icon: icon,
                child: _Paragraph(text),
              ),
            ],
            SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => launchUrl(
                  AppConstants.uriPrivacyPolicy,
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(MingCuteIcons.mgc_external_link_line),
                label: Text(
                  l10n.policy_screen_online,
                ),
              ),
            ),
          ],
        ),
      ),
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
    );
  }
}
