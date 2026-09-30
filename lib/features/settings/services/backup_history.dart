// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:shared_preferences/shared_preferences.dart';

/// Timestamps of the last JSON backup export/import, stored on the device
/// per user so that different accounts on the same phone don't mix.
class BackupHistory {
  BackupHistory(this.userId);

  final String userId;

  String get _exportKey => 'backup_last_export_$userId';
  String get _importKey => 'backup_last_import_$userId';

  Future<DateTime?> lastExport() => _read(_exportKey);
  Future<DateTime?> lastImport() => _read(_importKey);

  Future<void> recordExport(DateTime at) => _write(_exportKey, at);
  Future<void> recordImport(DateTime at) => _write(_importKey, at);

  Future<DateTime?> _read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(key);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> _write(String key, DateTime at) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, at.millisecondsSinceEpoch);
  }
}
