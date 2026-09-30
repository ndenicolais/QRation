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
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/utils/code_type_body.dart';
import 'package:qration/core/utils/code_type_icon.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Hero tag linking a code's type icon in a list to the details screen.
String codeIconHeroTag(String codeId) => 'code-type-icon-$codeId';

/// Card used by every code list (History, Favorites).
///
/// In normal mode tapping the card or the trailing arrow calls [onTap]; with
/// [selectable] the leading icon becomes a checkbox and tapping toggles
/// [selected] through [onSelectedChanged].
class CodeListTile extends StatelessWidget {
  const CodeListTile({
    super.key,
    required this.code,
    required this.onTap,
    this.showSource = false,
    this.selectable = false,
    this.selected = false,
    this.onSelectedChanged,
  });

  final CodeModel code;
  final VoidCallback onTap;

  /// Shows "Created"/"Scanned" above the content (lists mixing sources).
  final bool showSource;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool>? onSelectedChanged;

  /// Padding shared by the lists hosting these tiles.
  static EdgeInsets get listPadding =>
      EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h);

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final highlighted = selectable && selected;
    final icon = CodeTypeIcon.fromBarcodeType(
        code.barcode.type, code.barcode.rawValue ?? '');

    return Card(
      color: highlighted
          ? colorScheme.primary.withValues(alpha: 0.10)
          : Theme.of(context).cardTheme.color,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        side: BorderSide(
          color: highlighted
              ? colorScheme.primary.withValues(alpha: 0.60)
              : colorScheme.outline,
          width: 1.w,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: selectable ? () => onSelectedChanged?.call(!selected) : onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        leading: selectable
            ? Checkbox(
                value: selected,
                onChanged: (value) => onSelectedChanged?.call(value ?? false),
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : Hero(
                tag: codeIconHeroTag(code.id),
                child: Icon(icon.icon, color: colorScheme.primary),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSource) ...[
              Text(
                code.source.name.capitalize!,
                style: AppFonts.montserrat(
                  color: colorScheme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            Text(
              getContentBody(code).formattedContent,
              style: AppFonts.montserrat(
                color: colorScheme.onSurface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
          ],
        ),
        subtitle: Text(
          _dateFormat.format(code.date),
          style: AppFonts.montserrat(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
          ),
        ),
        trailing: selectable
            ? null
            : IconButton(
                tooltip: AppLocalizations.of(context)!
                    .history_screen_tooltip_details,
                icon: Icon(
                  MingCuteIcons.mgc_right_fill,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: onTap,
              ),
      ),
    );
  }
}
