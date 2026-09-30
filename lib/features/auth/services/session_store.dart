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

/// "Remember me" session flag persisted on the device.
///
/// Firebase keeps the signed-in user on its own; this flag only decides
/// whether the splash screen may skip the Welcome screen for that user.
class SessionStore {
  static const rememberMeKey = 'remember_me';
  static const userIdKey = 'user_id';

  Future<void> save(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(rememberMeKey, true);
    await prefs.setString(userIdKey, uid);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(rememberMeKey);
    await prefs.remove(userIdKey);
  }

  /// Uid of the remembered session, or null when none was saved.
  Future<String?> rememberedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(rememberMeKey) ?? false;
    final uid = prefs.getString(userIdKey) ?? '';
    return remember && uid.isNotEmpty ? uid : null;
  }

  /// Whether a signed-in Firebase user with [signedInUid] may be restored
  /// straight into the app.
  Future<bool> canRestore(String? signedInUid) async {
    if (signedInUid == null) return false;
    return await rememberedUserId() == signedInUid;
  }
}
