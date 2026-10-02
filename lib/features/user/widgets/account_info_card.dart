// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:intl/intl.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/widgets/section_card.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({super.key, required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final creationTime = currentUser.metadata.creationTime;
    final formattedDate = creationTime != null
        ? DateFormat('dd/MM/yyyy').format(creationTime)
        : 'N/A';

    return SectionCard(
      title: l10n.database_screen_account_title,
      icon: MingCuteIcons.mgc_user_3_fill,
      child: Column(
        children: [
          _InfoRow(
            icon: MingCuteIcons.mgc_card_pay_fill,
            label: l10n.database_screen_account_field_userid,
            value: currentUser.uid,
            isMonospace: true,
          ),
          const _InfoDivider(),
          _InfoRow(
            icon: MingCuteIcons.mgc_user_2_fill,
            label: l10n.database_screen_account_field_name,
            value: currentUser.displayName ?? 'N/A',
          ),
          const _InfoDivider(),
          _InfoRow(
            icon: MingCuteIcons.mgc_mail_fill,
            label: l10n.database_screen_account_field_email,
            value: currentUser.email ?? 'N/A',
          ),
          const _InfoDivider(),
          _InfoRow(
            icon: MingCuteIcons.mgc_calendar_fill,
            label: l10n.database_screen_account_field_date,
            value: formattedDate,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isMonospace = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.4,
                      ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: isMonospace
                      ? AppFonts.monospace(
                          color: theme.colorScheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                      : Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    // Color and thickness come from the theme dividerTheme.
    return const Divider(height: 1);
  }
}
