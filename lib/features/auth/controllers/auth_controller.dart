// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/widgets/app_toast.dart';
import 'package:qration/features/user/models/user_model.dart';
import 'package:qration/features/auth/services/session_store.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  AuthController({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
    SessionStore? session,
    void Function(String route)? navigateTo,
    VoidCallback? navigateBack,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _session = session ?? SessionStore(),
        _navigateTo = navigateTo ?? ((route) => Get.offAllNamed(route)),
        _navigateBack = navigateBack ?? (() => Get.back());

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  /// One `initialize()` per [GoogleSignIn] object: the plugin requires it to
  /// be called exactly once, and awaited, before any other call. Keyed by
  /// instance so tests with fresh mocks still initialize each of them.
  static final _googleInit = Expando<Future<void>>();

  Future<void> _ensureGoogleSignIn() =>
      _googleInit[_googleSignIn] ??= _googleSignIn.initialize();
  final SessionStore _session;

  /// Replaces the navigation stack with a route (injectable for tests).
  final void Function(String route) _navigateTo;
  final VoidCallback _navigateBack;
  final _logger = Logger();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final isLoading = false.obs;
  final passwordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final rememberMe = false.obs;

  /// Last error raised by an auth operation (also shown as a toast).
  Object? lastError;

  User? get currentUser => _auth.currentUser;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Clears the shared login/signup form. The controller is app-wide
  /// (AppBinding), so without this the typed email and password would stay
  /// in memory and reappear on the next visit to the auth screens.
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
    passwordVisible.value = false;
    confirmPasswordVisible.value = false;
    rememberMe.value = false;
  }

  void togglePassword() => passwordVisible.value = !passwordVisible.value;
  void toggleConfirmPassword() =>
      confirmPasswordVisible.value = !confirmPasswordVisible.value;

  // ─── LOGIN ───────────────────────────────────────────────────────────────

  Future<void> login(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    await submitLogin();
  }

  /// Login with the form values, already validated by [login].
  Future<void> submitLogin() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) throw Exception('email_not_found');

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (rememberMe.value) await _saveSession();
      clearForm();
      _navigateTo(AppRoutes.home);
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _ensureGoogleSignIn();
      final GoogleSignInAccount googleUser;
      try {
        googleUser = await _googleSignIn.authenticate();
      } on GoogleSignInException catch (e) {
        // Closing the account picker is not an error.
        if (e.code == GoogleSignInExceptionCode.canceled) return;
        rethrow;
      }

      // Firebase only needs the ID token: no OAuth scopes are requested, so
      // there is no access token to fetch through `authorizationClient`.
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set(
                UserModel(
                  userEmail: user.email!,
                  userName: user.displayName ?? 'User',
                  userImage: user.photoURL,
                ).toFirestore(),
              );
        }
      }

      // Google sign-in is always remembered: the account is already managed
      // by the device, so asking again at every launch adds no security.
      rememberMe.value = true;
      await _saveSession(uid: user?.uid);
      clearForm();
      _navigateTo(AppRoutes.home);
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── SIGNUP ──────────────────────────────────────────────────────────────

  Future<void> signup(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    await submitSignup();
  }

  /// Signup with the form values, already validated by [signup].
  Future<void> submitSignup() async {
    isLoading.value = true;
    try {
      final emailCheck = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: emailController.text.trim())
          .get();

      if (emailCheck.docs.isNotEmpty) throw Exception('email_already_register');

      final result = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set(
              UserModel(
                userEmail: emailController.text.trim(),
                userName: nameController.text.trim(),
              ).toFirestore(),
            );
        await _saveSession(uid: result.user!.uid);
        _logger.i('User registered');
        clearForm();
        _navigateTo(AppRoutes.home);
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── RESET PASSWORD ──────────────────────────────────────────────────────

  Future<void> resetPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    await submitResetPassword();
  }

  /// Password reset for the form email, already validated.
  Future<void> submitResetPassword() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) throw Exception('email_not_found');

      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      clearForm();
      _navigateBack();
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── LOGOUT ──────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _ensureGoogleSignIn();
      await _googleSignIn.signOut();
      await _session.clear();
      clearForm();
      _navigateTo(AppRoutes.welcome);
    } catch (e) {
      _logger.e('Logout error: $e');
    }
  }

  // ─── DELETE ACCOUNT ──────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final codesSnap = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('codes')
          .get();
      for (final doc in codesSnap.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await logout();
    } catch (e) {
      _logger.e('Delete account error: $e');
      rethrow;
    }
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  Future<void> _saveSession({String? uid}) async {
    final id = uid ?? _auth.currentUser?.uid;
    if (id != null) await _session.save(id);
  }

  void _handleAuthError(Object e) {
    lastError = e;
    final msg = e.toString();
    _logger.e('Auth error: $msg');
    // Surface raw exception key so the UI can map it to a localized string
    // Nullable, unlike Get.context, which asserts that the app is mounted.
    final context = Get.key.currentContext;
    if (context != null) {
      showErrorToast(context, msg);
    }
  }

  // ─── USER DETAILS ────────────────────────────────────────────────────────

  Future<UserModel?> getUserDetails() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) return UserModel.fromFirestore(doc.data()!);
    return null;
  }
}
