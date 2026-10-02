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
import 'package:qration/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qration/core/widgets/app_toast.dart';

Future<void> requestCameraPermission(BuildContext context) async {
  PermissionStatus cameraPermission = await Permission.camera.status;

  if (!cameraPermission.isGranted) {
    cameraPermission = await Permission.camera.request();
  }

  if (cameraPermission.isDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_camera_denied,
      );
    }
    throw Exception('Camera permission denied');
  } else if (cameraPermission.isPermanentlyDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_camera_toast,
      );
    }
    await Future.delayed(Duration(milliseconds: 1200));
    openAppSettings();
    throw Exception('Camera permission permanently denied');
  }
}

Future<void> requestContactsPermission(BuildContext context) async {
  PermissionStatus contactsPermission = await Permission.contacts.status;

  if (!contactsPermission.isGranted) {
    contactsPermission = await Permission.contacts.request();
  }

  if (contactsPermission.isDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_contacts_denied,
      );
    }
    throw Exception('Contacts permission denied');
  } else if (contactsPermission.isPermanentlyDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_contacts_toast,
      );
    }
    await Future.delayed(Duration(milliseconds: 1200));
    openAppSettings();
    throw Exception('Contacts permission permanently denied');
  }
}
