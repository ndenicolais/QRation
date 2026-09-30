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
import 'package:qration/features/settings/services/backup_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('nothing recorded yet returns null', () async {
    final history = BackupHistory('uid-1');

    expect(await history.lastExport(), isNull);
    expect(await history.lastImport(), isNull);
  });

  test('records export and import independently', () async {
    final history = BackupHistory('uid-1');
    final exportAt = DateTime(2026, 9, 30, 10, 15);
    final importAt = DateTime(2026, 9, 30, 11, 45);

    await history.recordExport(exportAt);
    expect(await history.lastExport(), exportAt);
    expect(await history.lastImport(), isNull);

    await history.recordImport(importAt);
    expect(await history.lastImport(), importAt);
  });

  test('timestamps are kept per user', () async {
    await BackupHistory('uid-1').recordExport(DateTime(2026, 1, 1));

    expect(await BackupHistory('uid-2').lastExport(), isNull);
  });
}
