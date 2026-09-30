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
import 'package:qration/core/widgets/sync_status_banner.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/l10n/app_localizations.dart';

import '../../support/widget_test_helpers.dart';

void main() {
  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(SyncStatusBanner)))!;

  testWidgets('synced shows nothing', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const SyncStatusBanner(status: SyncStatus.synced),
    );

    final l10n = l10nOf(tester);
    expect(find.text(l10n.sync_status_offline), findsNothing);
    expect(find.text(l10n.sync_status_pending), findsNothing);
  });

  testWidgets('offline and pending show their message', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const SyncStatusBanner(status: SyncStatus.offline),
    );
    expect(find.text(l10nOf(tester).sync_status_offline), findsOneWidget);

    await pumpLocalizedWidget(
      tester,
      const SyncStatusBanner(status: SyncStatus.pending),
    );
    expect(find.text(l10nOf(tester).sync_status_pending), findsOneWidget);
  });
}
