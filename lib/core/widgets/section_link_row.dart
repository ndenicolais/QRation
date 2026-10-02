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
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_radius.dart';

/// Tappable title + subtitle row used inside a [SectionCard] to open
/// another screen or an external link.
class SectionLinkRow extends StatelessWidget {
  const SectionLinkRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingIcon = MingCuteIcons.mgc_right_fill,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.montserrat(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFonts.montserrat(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(trailingIcon, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
