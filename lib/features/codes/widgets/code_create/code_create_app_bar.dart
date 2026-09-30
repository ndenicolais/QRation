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
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/features/codes/widgets/code_create/discard_dialog.dart';

class CodeCreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CodeCreateAppBar({
    super.key,
    required this.title,
    required this.hasContent,
  });

  final String title;

  /// Whether leaving should first ask to discard the entered data.
  final bool Function() hasContent;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
        onPressed: () async {
          if (!hasContent()) {
            Get.back();
            return;
          }
          final shouldPop = await showDiscardDialog(context);
          if (shouldPop && context.mounted) Get.back();
        },
      ),
      // Colors and title style come from the theme appBarTheme.
      title: Text(title),
    );
  }
}
