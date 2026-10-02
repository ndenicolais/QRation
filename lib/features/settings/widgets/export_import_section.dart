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
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Every way to get codes out of (and back into) the app, in one card:
/// documents to read or share (PDF, Excel, CSV) and the JSON backup to
/// save and restore, with when it was last made and restored.
class ExportImportSection extends StatelessWidget {
  const ExportImportSection({
    super.key,
    required this.onPdf,
    required this.onExcel,
    required this.onCsv,
    required this.onBackup,
    required this.onRestore,
    required this.lastBackupAt,
    required this.lastRestoreAt,
  });

  final VoidCallback onPdf;
  final VoidCallback onExcel;
  final VoidCallback onCsv;
  final VoidCallback onBackup;
  final VoidCallback onRestore;
  final DateTime? lastBackupAt;
  final DateTime? lastRestoreAt;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String format(DateTime? at) =>
        at == null ? l10n.database_screen_backup_never : _dateFormat.format(at);

    return SectionCard(
      title: l10n.database_screen_transfer_title,
      icon: MingCuteIcons.mgc_transfer_fill,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GroupHeader(
            title: l10n.database_screen_documents_title,
            description: l10n.database_screen_documents_description,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FormatTile(
                  icon: LineAwesomeIcons.file_pdf_solid,
                  label: l10n.database_screen_pdf_download,
                  onTap: onPdf,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FormatTile(
                  icon: LineAwesomeIcons.file_excel_solid,
                  label: l10n.database_screen_excel_download,
                  onTap: onExcel,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FormatTile(
                  icon: LineAwesomeIcons.file_csv_solid,
                  label: l10n.database_screen_csv_download,
                  onTap: onCsv,
                ),
              ),
            ],
          ),
          Divider(height: 32),
          _GroupHeader(
            title: l10n.database_screen_backup_title,
            description: l10n.database_screen_backup_description,
          ),
          SizedBox(height: 12),
          // Wrap, not Row: with a large system text size the two buttons go
          // on separate lines instead of squeezing their labels.
          LayoutBuilder(
            builder: (context, constraints) {
              final half = (constraints.maxWidth - 10) / 2;
              final buttonStyle = OutlinedButton.styleFrom(
                minimumSize: Size(half, 48),
              );
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    style: buttonStyle,
                    onPressed: onBackup,
                    icon: const Icon(MingCuteIcons.mgc_file_export_line),
                    label: Text(l10n.database_screen_backup_create),
                  ),
                  OutlinedButton.icon(
                    style: buttonStyle,
                    onPressed: onRestore,
                    icon: const Icon(MingCuteIcons.mgc_file_import_line),
                    label: Text(l10n.database_screen_backup_restore),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 14),
          _DateRow(
            label: l10n.database_screen_backup_last_export,
            value: format(lastBackupAt),
          ),
          SizedBox(height: 6),
          _DateRow(
            label: l10n.database_screen_backup_last_import,
            value: format(lastRestoreAt),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.labelLarge),
        SizedBox(height: 4),
        Text(description, style: textTheme.bodySmall),
      ],
    );
  }
}

class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Container(
          constraints: BoxConstraints(minHeight: 88),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: colorScheme.primary),
              SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: textTheme.bodySmall)),
        Text(value, style: textTheme.labelMedium),
      ],
    );
  }
}
