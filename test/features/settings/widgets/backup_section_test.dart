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
import 'package:qration/features/settings/widgets/backup_section.dart';
import 'package:qration/l10n/app_localizations.dart';

import '../../../support/widget_test_helpers.dart';

void main() {
  testWidgets('shows "never" when no backup was made', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const BackupSection(lastExportAt: null, lastImportAt: null),
    );

    final l10n =
        AppLocalizations.of(tester.element(find.byType(BackupSection)))!;
    expect(find.text(l10n.database_screen_backup_never), findsNWidgets(2));
  });

  testWidgets('formats the last export and import times', (tester) async {
    await pumpLocalizedWidget(
      tester,
      BackupSection(
        lastExportAt: DateTime(2026, 9, 30, 10, 5),
        lastImportAt: DateTime(2026, 8, 1, 23, 59),
      ),
    );

    expect(find.text('30/09/2026 10:05'), findsOneWidget);
    expect(find.text('01/08/2026 23:59'), findsOneWidget);
  });
}
