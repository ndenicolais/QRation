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
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/core/theme/app_colors.dart';
import 'package:qration/core/widgets/app_delete_dialog.dart';
import 'package:qration/core/widgets/app_toast.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  DeleteAccountScreenState createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen>
    with TickerProviderStateMixin {
  final _authCtrl = Get.find<AuthController>();
  late AnimationController _loadingController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30.r),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  _buildBodyText(context),
                  SizedBox(height: 40.h),
                  _buildDeleteButton(context),
                ],
              ),
            ),
          ),
          if (_isLoading) _buildDeleteLoading(context)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    AppDeleteDialog.show(
      context: context,
      title: AppLocalizations.of(context)!.delete_d_title,
      message: AppLocalizations.of(context)!.delete_d_description,
      onConfirm: () async {
        setState(() {
          _isLoading = true;
        });
        if (!mounted) return;
        await _authCtrl.deleteAccount();
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          showSuccessToast(
            context,
            AppLocalizations.of(context)!.toast_delete_success,
          );
          Get.offAllNamed(AppRoutes.welcome);
        }
      },
    );
  }

  // Colors and title style come from the theme appBarTheme.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(MingCuteIcons.mgc_large_arrow_left_fill),
        onPressed: Get.back,
      ),
      title: Text(AppLocalizations.of(context)!.delete_title),
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          MingCuteIcons.mgc_warning_fill,
          color: AppColors.error,
          size: 100.sp,
        ),
        SizedBox(height: 40.h),
        SizedBox(
          width: 420.w,
          child: Text(
            AppLocalizations.of(context)!.delete_description,
            textAlign: TextAlign.center,
            style: AppFonts.montserrat(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: 180.w,
      height: 80.h,
      child: ElevatedButton.icon(
        onPressed: _deleteAccount,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r))),
        icon: Icon(
          MingCuteIcons.mgc_delete_2_fill,
          size: 32.sp,
          color: Colors.white,
        ),
        label: Text(
          AppLocalizations.of(context)!.delete_d_title,
          style: AppFonts.montserrat(
            color: AppColors.qrWhite,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
      child: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.5).animate(
            CurvedAnimation(
              parent: _loadingController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Icon(
            MingCuteIcons.mgc_eraser_fill,
            size: 50.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
