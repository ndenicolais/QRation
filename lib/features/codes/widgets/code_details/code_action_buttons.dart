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
import 'package:flutter/services.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:share_plus/share_plus.dart';

/// Row of labeled quick actions (copy, favorite, save image, share).
class CodeActionButtons extends StatelessWidget {
  const CodeActionButtons({
    super.key,
    required this.controller,
    required this.onCopy,
    required this.onSave,
  });

  final CodeDetailsController controller;
  final VoidCallback onCopy;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: MingCuteIcons.mgc_copy_2_fill,
            label: l10n.code_details_screen_action_button_copy,
            onTap: onCopy,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Obx(() {
            final isFavorite = controller.isFavorite.value;
            return _ActionTile(
              icon: isFavorite
                  ? MingCuteIcons.mgc_heart_fill
                  : MingCuteIcons.mgc_heart_line,
              label: l10n.code_details_screen_action_button_favorite,
              onTap: controller.toggleFavorite,
              highlighted: isFavorite,
            );
          }),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionTile(
            icon: MingCuteIcons.mgc_download_2_fill,
            label: l10n.code_details_screen_action_button_save,
            onTap: onSave,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionTile(
            icon: MingCuteIcons.mgc_share_2_fill,
            label: l10n.code_details_screen_action_button_share,
            onTap: () => Share.share(controller.code.barcode.rawValue ?? ''),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: highlighted
          ? colorScheme.primary.withValues(alpha: 0.14)
          : theme.cardTheme.color ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        side: BorderSide(
          color: highlighted
              ? colorScheme.primary.withValues(alpha: 0.6)
              : colorScheme.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorScheme.primary, size: 24.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.montserrat(
                  color: colorScheme.onSurface,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
