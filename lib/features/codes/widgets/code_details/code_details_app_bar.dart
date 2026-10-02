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
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class CodeDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CodeDetailsAppBar({
    super.key,
    required this.onEditNotes,
    required this.onDelete,
  });

  final VoidCallback onEditNotes;
  final VoidCallback onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Colors and title style come from the theme appBarTheme.
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
        onPressed: Get.back,
      ),
      title: Text(AppLocalizations.of(context)!.code_details_screen_title),
      actions: [
        _PopupMenu(onEditNotes: onEditNotes, onDelete: onDelete),
      ],
    );
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({required this.onEditNotes, required this.onDelete});

  final VoidCallback onEditNotes;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(MingCuteIcons.mgc_more_2_fill),
      onSelected: (value) {
        // PopupMenuButton's own route is still closing at this point;
        // opening another route (bottom sheet/dialog) synchronously here
        // races with that closing animation and can leave it invisible
        // while still stealing focus. Defer until the menu is fully gone.
        Future.delayed(const Duration(milliseconds: 300), () {
          if (value == 'notes') {
            onEditNotes();
          } else if (value == 'delete') {
            onDelete();
          }
        });
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem(
            context,
            'notes',
            MingCuteIcons.mgc_edit_4_fill,
            AppLocalizations.of(context)!.code_details_screen_menu_notes,
          ),
          _buildPopupMenuItem(
            context,
            'delete',
            MingCuteIcons.mgc_delete_3_fill,
            AppLocalizations.of(context)!.code_details_screen_menu_delete,
            color: Theme.of(context).colorScheme.error,
          ),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String text, {
    Color? color,
  }) {
    final itemColor = color ?? Theme.of(context).colorScheme.onSurface;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: itemColor),
          SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: itemColor,
                ),
          ),
        ],
      ),
    );
  }
}
