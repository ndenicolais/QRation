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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String answer;
  final IconData iconClosed;
  final IconData iconOpened;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.answer,
    this.iconClosed = MingCuteIcons.mgc_down_fill,
    this.iconOpened = MingCuteIcons.mgc_up_fill,
  });

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      // Sits inside a SectionCard: no own borders or side padding.
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(bottom: 12.h),
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        widget.title,
        style: AppFonts.montserrat(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        isExpanded ? widget.iconOpened : widget.iconClosed,
        color: isExpanded ? colorScheme.primary : colorScheme.onSurfaceVariant,
        size: 24.sp,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      children: [
        Text(
          widget.answer,
          style: AppFonts.montserrat(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
