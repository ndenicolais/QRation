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
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/constants/app_constants.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/core/widgets/section_link_row.dart';
import 'package:qration/features/settings/widgets/custom_expansiontile.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final faqs = [
      (l10n.support_screen_faq_q1, l10n.support_screen_faq_a1),
      (l10n.support_screen_faq_q2, l10n.support_screen_faq_a2),
      (l10n.support_screen_faq_q3, l10n.support_screen_faq_a3),
      (l10n.support_screen_faq_q4, l10n.support_screen_faq_a4),
      (l10n.support_screen_faq_q5, l10n.support_screen_faq_a5),
      (l10n.support_screen_faq_q7, l10n.support_screen_faq_a7),
    ];

    return Scaffold(
      // Colors and title style come from the theme appBarTheme.
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
          onPressed: Get.back,
        ),
        title: Text(l10n.support_screen_title),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              SectionCard(
                title: l10n.support_screen_contacts_text,
                icon: MingCuteIcons.mgc_mail_send_fill,
                child: SectionLinkRow(
                  title: l10n.support_screen_contacts_info,
                  subtitle: l10n.support_screen_contacts_decription,
                  trailingIcon: MingCuteIcons.mgc_external_link_line,
                  onTap: () => launchUrl(AppConstants.uriMail),
                ),
              ),
              SectionCard(
                title: l10n.support_screen_faq_text,
                icon: MingCuteIcons.mgc_question_fill,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.support_screen_faq_decription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    for (final (question, answer) in faqs)
                      CustomExpansionTile(title: question, answer: answer),
                  ],
                ),
              ),
              SectionCard(
                title: l10n.support_screen_documentation_text,
                icon: MingCuteIcons.mgc_book_6_fill,
                child: SectionLinkRow(
                  title: l10n.support_screen_documentation_info,
                  subtitle: l10n.support_screen_documentation_decription,
                  trailingIcon: MingCuteIcons.mgc_external_link_line,
                  onTap: () => launchUrl(
                    AppConstants.uriGithubRepository,
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
