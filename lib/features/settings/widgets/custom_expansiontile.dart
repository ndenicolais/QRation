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
    return ExpansionTile(
      title: Text(
        widget.title,
        style: AppFonts.montserrat(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 16.sp,
        ),
      ),
      trailing: Icon(
        isExpanded ? widget.iconOpened : widget.iconClosed,
        color: isExpanded
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.tertiary,
        size: 24.sp,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      children: [
        Padding(
          padding: EdgeInsets.all(12.r),
          child: Text(
            widget.answer,
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
