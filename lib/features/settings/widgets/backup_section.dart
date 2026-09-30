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
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/l10n/app_localizations.dart';

/// When the JSON backup was last exported and imported on this device.
class BackupSection extends StatelessWidget {
  const BackupSection({
    super.key,
    required this.lastExportAt,
    required this.lastImportAt,
  });

  final DateTime? lastExportAt;
  final DateTime? lastImportAt;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String format(DateTime? at) =>
        at == null ? l10n.database_screen_backup_never : _dateFormat.format(at);

    return SectionCard(
      title: l10n.database_screen_backup_title,
      icon: MingCuteIcons.mgc_safe_box_fill,
      child: Column(
        children: [
          _BackupRow(
            icon: MingCuteIcons.mgc_file_export_line,
            label: l10n.database_screen_backup_last_export,
            value: format(lastExportAt),
          ),
          Divider(height: 20.h),
          _BackupRow(
            icon: MingCuteIcons.mgc_file_import_line,
            label: l10n.database_screen_backup_last_import,
            value: format(lastImportAt),
          ),
        ],
      ),
    );
  }
}

class _BackupRow extends StatelessWidget {
  const _BackupRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colorScheme.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: AppFonts.montserrat(
              color: colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
        ),
        Text(
          value,
          style: AppFonts.montserrat(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
