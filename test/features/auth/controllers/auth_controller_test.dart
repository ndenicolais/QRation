// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/auth/services/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  // Error paths look up the app context for the toast through a GlobalKey.
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockGoogleSignIn googleSignIn;
  late SessionStore session;
  late List<String> routes;
  late int backCalls;

  const email = 'mario@example.com';

  AuthController createController({MockUser? user, bool signedIn = false}) {
    auth = MockFirebaseAuth(
      signedIn: signedIn,
      mockUser: user ?? MockUser(uid: 'uid-1', email: email),
    );
    return AuthController(
      auth: auth,
      firestore: firestore,
      googleSignIn: googleSignIn,
      session: session,
      navigateTo: routes.add,
      navigateBack: () => backCalls++,
    );
  }

  Future<void> registerUserDoc(String uid, String userEmail) {
    return firestore.collection('users').doc(uid).set({
      'userEmail': userEmail,
      'userName': 'Mario',
    });
  }

  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    firestore = FakeFirebaseFirestore();
    googleSignIn = MockGoogleSignIn();
    session = SessionStore();
    routes = [];
    backCalls = 0;
  });

  group('login', () {
    test('unknown email is rejected without navigating', () async {
      final controller = createController();
      controller.emailController.text = email;
      controller.passwordController.text = 'secret';

      await controller.submitLogin();

      expect(routes, isEmpty);
      expect(controller.lastError.toString(), contains('email_not_found'));
      expect(controller.isLoading.value, isFalse);
    });

    test('registered email logs in, remembers and clears the form', () async {
      await registerUserDoc('uid-1', email);
      final controller = createController();
      controller.emailController.text = email;
      controller.passwordController.text = 'secret';
      controller.rememberMe.value = true;

      await controller.submitLogin();

      expect(routes, [AppRoutes.home]);
      expect(await session.rememberedUserId(), 'uid-1');
      expect(controller.emailController.text, isEmpty);
      expect(controller.passwordController.text, isEmpty);
      expect(controller.rememberMe.value, isFalse);
    });

    test('without "remember me" no session is saved', () async {
      await registerUserDoc('uid-1', email);
      final controller = createController();
      controller.emailController.text = email;
      controller.passwordController.text = 'secret';

      await controller.submitLogin();

      expect(routes, [AppRoutes.home]);
      expect(await session.rememberedUserId(), isNull);
    });
  });

  group('google sign-in', () {
    test('cancelled picker does nothing', () async {
      when(() => googleSignIn.signIn()).thenAnswer((_) async => null);
      final controller = createController();

      await controller.loginWithGoogle();

      expect(routes, isEmpty);
      expect(controller.isLoading.value, isFalse);
    });

    test('creates the profile once and always remembers the session', () async {
      final account = MockGoogleSignInAccount();
      final authentication = MockGoogleSignInAuthentication();
      when(() => googleSignIn.signIn()).thenAnswer((_) async => account);
      when(() => account.authentication)
          .thenAnswer((_) async => authentication);
      when(() => authentication.accessToken).thenReturn('access');
      when(() => authentication.idToken).thenReturn('id');
      final controller = createController(
        user: MockUser(uid: 'g-1', email: 'g@example.com', displayName: 'G'),
      );

      await controller.loginWithGoogle();

      expect(routes, [AppRoutes.home]);
      expect(await session.rememberedUserId(), 'g-1');
      final doc = await firestore.collection('users').doc('g-1').get();
      expect(doc.data()?['userEmail'], 'g@example.com');
    });
  });

  group('signup', () {
    test('already registered email is rejected', () async {
      await registerUserDoc('other', email);
      final controller = createController();
      controller.emailController.text = email;
      controller.passwordController.text = 'secret';

      await controller.submitSignup();

      expect(routes, isEmpty);
      expect(
        controller.lastError.toString(),
        contains('email_already_register'),
      );
    });

    test('new email creates the profile and remembers the session', () async {
      final controller = createController();
      controller.nameController.text = 'Mario';
      controller.emailController.text = 'new@example.com';
      controller.passwordController.text = 'secret';

      await controller.submitSignup();

      expect(routes, [AppRoutes.home]);
      final users = await firestore
          .collection('users')
          .where('userEmail', isEqualTo: 'new@example.com')
          .get();
      expect(users.docs.single.data()['userName'], 'Mario');
      expect(await session.rememberedUserId(), users.docs.single.id);
      expect(controller.nameController.text, isEmpty);
    });
  });

  group('reset password', () {
    test('unknown email is rejected', () async {
      final controller = createController();
      controller.emailController.text = email;

      await controller.submitResetPassword();

      expect(backCalls, 0);
      expect(controller.lastError.toString(), contains('email_not_found'));
    });

    test('registered email sends the reset and goes back', () async {
      await registerUserDoc('uid-1', email);
      final controller = createController();
      controller.emailController.text = email;

      await controller.submitResetPassword();

      expect(backCalls, 1);
      expect(controller.emailController.text, isEmpty);
    });
  });

  test('logout signs out, forgets the session and goes to welcome', () async {
    when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
    await session.save('uid-1');
    final controller = createController(signedIn: true);
    controller.emailController.text = email;

    await controller.logout();

    expect(auth.currentUser, isNull);
    expect(await session.rememberedUserId(), isNull);
    expect(controller.emailController.text, isEmpty);
    expect(routes, [AppRoutes.welcome]);
    verify(() => googleSignIn.signOut()).called(1);
  });

  test('deleteAccount removes codes and profile, then logs out', () async {
    when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
    await registerUserDoc('uid-1', email);
    final codes =
        firestore.collection('users').doc('uid-1').collection('codes');
    await codes.add({'rawValue': 'a'});
    await codes.add({'rawValue': 'b'});
    final controller = createController(signedIn: true);

    await controller.deleteAccount();

    expect((await codes.get()).docs, isEmpty);
    expect(
      (await firestore.collection('users').doc('uid-1').get()).exists,
      isFalse,
    );
    expect(routes, [AppRoutes.welcome]);
  });

  test('getUserDetails reads the profile of the signed-in user', () async {
    await registerUserDoc('uid-1', email);
    final controller = createController(signedIn: true);

    final user = await controller.getUserDetails();

    expect(user?.userEmail, email);
    expect(user?.userName, 'Mario');
  });
}
