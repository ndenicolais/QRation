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
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/widgets/app_button.dart';
import 'package:qration/core/widgets/app_loader.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/user/models/user_model.dart';
import 'package:qration/features/user/widgets/account_info_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _authCtrl = Get.find<AuthController>();
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await _authCtrl.getUserDetails();
    if (mounted) {
      setState(() {
        _user = u;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Colors and title style come from the theme appBarTheme.
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
          onPressed: Get.back,
        ),
        title: Text(l10n.user_screen_title),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: AppLoader())
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(user: _user, firebaseUser: firebaseUser),
                    SizedBox(height: 24),
                    if (firebaseUser != null)
                      AccountInfoCard(currentUser: firebaseUser),
                    SizedBox(height: 28),
                    AppButton.outlined(
                      label: l10n.user_screen_logout_button,
                      icon: MingCuteIcons.mgc_exit_fill,
                      onPressed: _authCtrl.logout,
                    ),
                    SizedBox(height: 12),
                    AppButton.outlined(
                      label: l10n.settings_tile_delete_account,
                      icon: MingCuteIcons.mgc_delete_2_fill,
                      foregroundColor: colorScheme.error,
                      onPressed: () => Get.toNamed(AppRoutes.deleteAccount),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Avatar with the user's photo (or initial), name and email.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.firebaseUser});

  final UserModel? user;
  final User? firebaseUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = user?.userName ?? firebaseUser?.displayName ?? '';
    final email = user?.userEmail ?? firebaseUser?.email ?? '';
    final photoUrl = user?.userImage ?? firebaseUser?.photoURL;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    final fallback = Center(
      child: Text(
        initial,
        style: AppFonts.montserrat(
          color: colorScheme.primary,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.primary, width: 2),
          ),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.14),
            ),
            clipBehavior: Clip.antiAlias,
            child: photoUrl != null && photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => fallback,
                  )
                : fallback,
          ),
        ),
        if (name.isNotEmpty) ...[
          SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppFonts.montserrat(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (email.isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            email,
            textAlign: TextAlign.center,
            style: AppFonts.montserrat(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
