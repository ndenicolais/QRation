// QRation â€” Copyright Â© 2026 Nicola De Nicolais â€” All Rights Reserved.
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:share_plus/share_plus.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          MingCuteIcons.mgc_copy_fill,
          onCopy,
          'btnCopy',
          l10n.code_details_screen_action_button_copy,
        ),
        Obx(() => _buildActionButton(
              context,
              controller.isFavorite.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              controller.toggleFavorite,
              'btnFavorites',
              l10n.code_details_screen_action_button_favorite,
            )),
        _buildActionButton(
          context,
          MingCuteIcons.mgc_download_2_fill,
          onSave,
          'btnSave',
          l10n.code_details_screen_action_button_save,
        ),
        _buildActionButton(
          context,
          MingCuteIcons.mgc_share_2_fill,
          () {
            Share.share(controller.code.barcode.rawValue ?? '');
          },
          'btnShare',
          l10n.code_details_screen_action_button_share,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    String heroTag,
    String tooltip,
  ) {
    return SizedBox(
      width: 52.w,
      height: 52.h,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        heroTag: heroTag,
        tooltip: tooltip,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
