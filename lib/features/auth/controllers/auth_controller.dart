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

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();
  final _session = SessionStore();
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
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
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
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── SIGNUP ──────────────────────────────────────────────────────────────

  Future<void> signup(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
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
        Get.offAllNamed(AppRoutes.home);
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
    isLoading.value = true;
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userEmail', isEqualTo: emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) throw Exception('email_not_found');

      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      clearForm();
      Get.back();
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
      await _googleSignIn.signOut();
      await _session.clear();
      clearForm();
      Get.offAllNamed(AppRoutes.welcome);
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

  void _handleAuthError(dynamic e) {
    final msg = e.toString();
    _logger.e('Auth error: $msg');
    // Surface raw exception key so the UI can map it to a localized string
    final context = Get.context;
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
