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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qration/core/theme/app_fonts.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/settings/widgets/account_info_card.dart';
import 'package:qration/features/user/models/user_model.dart';

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
    final theme = Theme.of(context);
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: theme.colorScheme.secondary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          l10n.user_screen_title,
          style: AppFonts.montserrat(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    _buildAvatar(theme, firebaseUser),
                    SizedBox(height: 24.h),
                    if (firebaseUser != null)
                      AccountInfoCard(currentUser: firebaseUser),
                    SizedBox(height: 32.h),
                    _buildLogoutButton(context, l10n, theme),
                    SizedBox(height: 12.h),
                    _buildDeleteAccountButton(context, l10n, theme),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, User? firebaseUser) {
    final name = _user?.userName ?? firebaseUser?.displayName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final photoUrl = _user?.userImage ?? firebaseUser?.photoURL;

    return Center(
      child: Container(
        width: 96.r,
        height: 96.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.secondary,
        ),
        clipBehavior: Clip.antiAlias,
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitial(theme, initial),
              )
            : _buildInitial(theme, initial),
      ),
    );
  }

  Widget _buildInitial(ThemeData theme, String initial) {
    return Center(
      child: Text(
        initial,
        style: AppFonts.montserrat(
          color: theme.colorScheme.primary,
          fontSize: 42.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        icon: Icon(MingCuteIcons.mgc_exit_fill,
            color: theme.colorScheme.secondary),
        label: Text(
          l10n.user_screen_logout_button,
          style: AppFonts.montserrat(
            color: theme.colorScheme.secondary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.secondary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        onPressed: () => _authCtrl.logout(),
      ),
    );
  }

  Widget _buildDeleteAccountButton(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        icon: const Icon(MingCuteIcons.mgc_delete_fill, color: AppColors.error),
        label: Text(
          l10n.settings_tile_delete_account,
          style: AppFonts.montserrat(
            color: AppColors.error,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        onPressed: () => Get.toNamed(AppRoutes.deleteAccount),
      ),
    );
  }
}
