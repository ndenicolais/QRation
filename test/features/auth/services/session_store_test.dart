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
import 'package:qration/features/auth/services/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final store = SessionStore();

  test('no saved session cannot be restored', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await store.rememberedUserId(), isNull);
    expect(await store.canRestore('uid-1'), isFalse);
  });

  test('saved session restores only the same signed-in user', () async {
    SharedPreferences.setMockInitialValues({});
    await store.save('uid-1');

    expect(await store.rememberedUserId(), 'uid-1');
    expect(await store.canRestore('uid-1'), isTrue);
    expect(await store.canRestore('uid-2'), isFalse);
    expect(await store.canRestore(null), isFalse);
  });

  test('clear forgets the session', () async {
    SharedPreferences.setMockInitialValues({});
    await store.save('uid-1');
    await store.clear();

    expect(await store.canRestore('uid-1'), isFalse);
  });

  test('legacy flag without a user id is not restored', () async {
    SharedPreferences.setMockInitialValues({SessionStore.rememberMeKey: true});

    expect(await store.canRestore('uid-1'), isFalse);
  });
}
