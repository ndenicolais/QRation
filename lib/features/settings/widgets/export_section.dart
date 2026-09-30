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
import 'package:qration/core/theme/app_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/widgets/section_card.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({
    super.key,
    required this.onPdf,
    required this.onExcel,
    required this.onCsv,
  });

  final VoidCallback onPdf;
  final VoidCallback onExcel;
  final VoidCallback onCsv;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SectionCard(
      title: l10n.database_screen_export_title,
      icon: MingCuteIcons.mgc_file_export_fill,
      child: Row(
        children: [
          Expanded(
            child: _ExportCard(
              iconData: LineAwesomeIcons.file_pdf_solid,
              text: l10n.database_screen_pdf_download,
              onTap: onPdf,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _ExportCard(
              iconData: LineAwesomeIcons.file_excel_solid,
              text: l10n.database_screen_excel_download,
              onTap: onExcel,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _ExportCard(
              iconData: LineAwesomeIcons.file_csv_solid,
              text: l10n.database_screen_csv_download,
              onTap: onCsv,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.iconData,
    required this.text,
    required this.onTap,
  });

  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        constraints: BoxConstraints(minHeight: 100.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 30.sp, color: theme.colorScheme.primary),
            SizedBox(height: 8.h),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.montserrat(
                color: theme.colorScheme.onSurface,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
