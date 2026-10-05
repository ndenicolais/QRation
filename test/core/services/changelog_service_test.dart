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
import 'package:qration/core/constants/changelog.dart';
import 'package:qration/core/services/changelog_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ChangelogEntry entry(String version) =>
    ChangelogEntry(version: version, items: const []);

void main() {
  // Newest first, as in changelog.dart.
  final entries = [entry('3.0.0'), entry('2.0.0'), entry('1.0.0')];

  Future<String?> lastSeen() async => (await SharedPreferences.getInstance())
      .getString(ChangelogService.prefsLastSeenVersion);

  void givenLastSeen(String? version) => SharedPreferences.setMockInitialValues(
        {if (version != null) ChangelogService.prefsLastSeenVersion: version},
      );

  test('fresh install shows nothing but records the version', () async {
    givenLastSeen(null);
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        isEmpty);
    expect(await lastSeen(), '3.0.0');
  });

  test('shows only the entries newer than the last seen version', () async {
    givenLastSeen('1.0.0');
    final result =
        await ChangelogService.pendingEntries('3.0.0', entries: entries);
    expect(result.map((e) => e.version), ['3.0.0', '2.0.0']);
    expect(await lastSeen(), '3.0.0');
  });

  test('shows everything when the last seen version is unknown', () async {
    givenLastSeen('0.9.0');
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        hasLength(3));
  });

  test('shows nothing when the version was already seen', () async {
    givenLastSeen('3.0.0');
    expect(await ChangelogService.pendingEntries('3.0.0', entries: entries),
        isEmpty);
  });
}
