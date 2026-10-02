// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter_test/flutter_test.dart';
import 'package:qration/features/settings/widgets/export_import_section.dart';
import 'package:qration/l10n/app_localizations.dart';

import '../../../support/widget_test_helpers.dart';

void main() {
  testWidgets('each document format and backup action has its own callback',
      (tester) async {
    final taps = <String, int>{};
    void count(String key) => taps[key] = (taps[key] ?? 0) + 1;

    await pumpLocalizedWidget(
      tester,
      ExportImportSection(
        onPdf: () => count('pdf'),
        onExcel: () => count('excel'),
        onCsv: () => count('csv'),
        onBackup: () => count('backup'),
        onRestore: () => count('restore'),
        lastBackupAt: null,
        lastRestoreAt: null,
      ),
    );
    final l10n =
        AppLocalizations.of(tester.element(find.byType(ExportImportSection)))!;

    await tester.tap(find.text(l10n.database_screen_pdf_download));
    await tester.tap(find.text(l10n.database_screen_excel_download));
    await tester.tap(find.text(l10n.database_screen_csv_download));
    await tester.tap(find.text(l10n.database_screen_csv_download));
    await tester.tap(find.text(l10n.database_screen_backup_create));
    await tester.tap(find.text(l10n.database_screen_backup_restore));

    expect(taps, {'pdf': 1, 'excel': 1, 'csv': 2, 'backup': 1, 'restore': 1});
  });

  testWidgets('shows "never" when no backup was made', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const ExportImportSection(
        onPdf: _noop,
        onExcel: _noop,
        onCsv: _noop,
        onBackup: _noop,
        onRestore: _noop,
        lastBackupAt: null,
        lastRestoreAt: null,
      ),
    );
    final l10n =
        AppLocalizations.of(tester.element(find.byType(ExportImportSection)))!;
    expect(find.text(l10n.database_screen_backup_never), findsNWidgets(2));
  });

  testWidgets('formats the last backup and restore times', (tester) async {
    await pumpLocalizedWidget(
      tester,
      ExportImportSection(
        onPdf: _noop,
        onExcel: _noop,
        onCsv: _noop,
        onBackup: _noop,
        onRestore: _noop,
        lastBackupAt: DateTime(2026, 9, 30, 10, 5),
        lastRestoreAt: DateTime(2026, 8, 1, 23, 59),
      ),
    );
    expect(find.text('30/09/2026 10:05'), findsOneWidget);
    expect(find.text('01/08/2026 23:59'), findsOneWidget);
  });
}

void _noop() {}
