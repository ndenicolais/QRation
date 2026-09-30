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
import 'package:toastification/toastification.dart';

void showAppToast(
  BuildContext context,
  String message, {
  bool isSuccess = true,
}) {
  toastification.show(
    context: context,
    type: isSuccess ? ToastificationType.success : ToastificationType.error,
    style: ToastificationStyle.flatColored,
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
    borderRadius: BorderRadius.circular(12),
    closeButtonShowType: CloseButtonShowType.onHover,
    showProgressBar: false,
    dragToClose: true,
  );
}

void showSuccessToast(BuildContext context, String message) =>
    showAppToast(context, message, isSuccess: true);

void showErrorToast(BuildContext context, String message) =>
    showAppToast(context, message, isSuccess: false);
