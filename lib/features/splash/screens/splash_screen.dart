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
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/features/auth/services/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (!seenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    try {
      final session = SessionStore();
      final rememberedUid = await session.rememberedUserId();
      if (rememberedUid != null) {
        final user = await _restoredUser();
        _logger.d('Session restore: remembered=$rememberedUid '
            'firebase=${user?.uid}');
        if (await session.canRestore(user?.uid)) {
          Get.offAllNamed(AppRoutes.home);
          return;
        }
      }
    } catch (e) {
      _logger.e('Session restore failed: $e');
    }

    Get.offAllNamed(AppRoutes.welcome);
  }

  /// Firebase restores the persisted user asynchronously at startup, so
  /// `currentUser` (and the first `authStateChanges()` event, which replays
  /// it) can still be null here. Only called when a session is remembered:
  /// wait for the first signed-in user, giving up after a timeout.
  Future<User?> _restoredUser() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) return auth.currentUser;
    return auth
        .authStateChanges()
        .firstWhere((user) => user != null)
        .timeout(const Duration(seconds: 5), onTimeout: () => null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 120,
              height: 120,
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1)),
            const SizedBox(height: 24),
            Text(
              'QRation',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.qrGold,
                    letterSpacing: 2,
                  ),
            )
                .animate()
                .fadeIn(delay: 150.ms, duration: 250.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
