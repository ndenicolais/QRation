// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [User] exposing only the fields the app reads.
class FakeUser extends Fake implements User {
  FakeUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;

  /// Set by [delete], so tests can check the account was removed.
  bool deleted = false;

  @override
  Future<void> delete() async => deleted = true;
}

class _FakeUserCredential extends Fake implements UserCredential {
  _FakeUserCredential(this.user);

  @override
  final User? user;
}

/// Stateful [FirebaseAuth] covering the calls the app makes: every sign-in
/// succeeds and signs in [mockUser], sign-up signs in a new user for the
/// given email, sign-out clears [currentUser].
class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  FakeFirebaseAuth({FakeUser? mockUser, bool signedIn = false})
      : mockUser = mockUser ?? FakeUser(uid: 'uid-1'),
        _currentUser = signedIn ? (mockUser ?? FakeUser(uid: 'uid-1')) : null;

  final FakeUser mockUser;
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  UserCredential _signIn(User user) {
    _currentUser = user;
    return _FakeUserCredential(user);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      _signIn(mockUser);

  @override
  Future<UserCredential> signInWithCredential(
          AuthCredential credential) async =>
      _signIn(mockUser);

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      _signIn(FakeUser(uid: 'uid-$email', email: email));

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) async {}

  @override
  Future<void> signOut() async => _currentUser = null;
}
