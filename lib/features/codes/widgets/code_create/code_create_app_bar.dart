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
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';
import 'package:qration/features/codes/widgets/code_create/discard_dialog.dart';

class CodeCreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CodeCreateAppBar({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final CodeCreateStandardController controller;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          MingCuteIcons.mgc_large_arrow_left_fill,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () async {
          if (!controller.hasContent()) {
            Get.back();
            return;
          }
          final shouldPop = await showDiscardDialog(context);
          if (shouldPop && context.mounted) Get.back();
        },
      ),
      title: Text(
        title,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
