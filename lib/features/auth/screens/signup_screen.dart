// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qration/core/widgets/app_logo.dart';
import 'package:qration/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:qration/core/routes/app_routes.dart';
import 'package:qration/core/widgets/app_button.dart';
import 'package:qration/core/widgets/app_textfield.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/auth/widgets/auth_divider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(MingCuteIcons.mgc_large_arrow_left_fill,
              color: theme.colorScheme.onSurface),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: const AppLogo(size: 80),
                ),
                const SizedBox(height: 40),
                Text(l10n.signup_title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.signup_subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: controller.nameController,
                  label: l10n.signup_name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(MingCuteIcons.mgc_user_3_line),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validator_name
                      : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: controller.emailController,
                  label: l10n.signup_email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(MingCuteIcons.mgc_mail_line),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? l10n.validator_email
                      : null,
                ),
                const SizedBox(height: 16),
                Obx(() => AppTextField(
                      controller: controller.passwordController,
                      label: l10n.signup_password,
                      obscureText: !controller.passwordVisible.value,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(MingCuteIcons.mgc_lock_line),
                      suffixIcon: IconButton(
                        tooltip: controller.passwordVisible.value
                            ? l10n.password_hide
                            : l10n.password_show,
                        icon: Icon(
                          controller.passwordVisible.value
                              ? MingCuteIcons.mgc_eye_line
                              : MingCuteIcons.mgc_eye_close_line,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? l10n.validator_password
                          : null,
                    )),
                const SizedBox(height: 16),
                Obx(() => AppTextField(
                      controller: controller.confirmPasswordController,
                      label: l10n.signup_confirm_password,
                      obscureText: !controller.confirmPasswordVisible.value,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(MingCuteIcons.mgc_lock_line),
                      suffixIcon: IconButton(
                        tooltip: controller.confirmPasswordVisible.value
                            ? l10n.password_hide
                            : l10n.password_show,
                        icon: Icon(
                          controller.confirmPasswordVisible.value
                              ? MingCuteIcons.mgc_eye_line
                              : MingCuteIcons.mgc_eye_close_line,
                        ),
                        onPressed: controller.toggleConfirmPassword,
                      ),
                      validator: (v) =>
                          (v != controller.passwordController.text)
                              ? l10n.validator_confirm_password
                              : null,
                    )),
                const SizedBox(height: 32),
                Obx(() => AppButton(
                      label: l10n.signup_button,
                      isLoading: controller.isLoading.value,
                      onPressed: () => controller.signup(formKey),
                    )),
                const SizedBox(height: 16),
                AuthDivider(label: l10n.login_or),
                const SizedBox(height: 16),
                Obx(() => AppButton.outlined(
                      label: l10n.login_google,
                      isLoading: controller.isLoading.value,
                      icon: MingCuteIcons.mgc_google_fill,
                      onPressed: controller.loginWithGoogle,
                    )),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: '${l10n.signup_have_account} ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: l10n.signup_login,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ])),
                  ),
                ),
              ]
                  .animate(interval: 50.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
          ),
        ),
      ),
    );
  }
}
