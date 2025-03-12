import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qration/widgets/custom_toast.dart';

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

Future<void> requestLocationPermission(BuildContext context) async {
  PermissionStatus locationPermission = await Permission.location.status;

  if (!locationPermission.isGranted) {
    locationPermission = await Permission.location.request();
  }

  if (locationPermission.isDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_location_denied,
      );
    }
    throw Exception('Location permission denied');
  } else if (locationPermission.isPermanentlyDenied) {
    if (context.mounted) {
      showErrorToast(
        context,
        AppLocalizations.of(context)!.permission_location_toast,
      );
    }
    await Future.delayed(Duration(milliseconds: 1200));
    openAppSettings();
    throw Exception('Location permission permanently denied');
  }
}

Future<String> requestStoragePermission(
  BuildContext context,
  Function pickImage,
) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkVersion = androidInfo.version.sdkInt;

    // If SDK version is <= 32 (Android 12 or earlier)
    if (sdkVersion <= 32) {
      PermissionStatus filePermission = await Permission.storage.status;

      if (filePermission.isGranted) {
        return await pickImage();
      } else {
        filePermission = await Permission.storage.request();

        if (filePermission.isGranted) {
          return await pickImage();
        } else if (filePermission.isDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_denied,
            );
          }
          throw Exception('Storage permission denied');
        } else if (filePermission.isPermanentlyDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_toast,
            );
          }
          await Future.delayed(Duration(milliseconds: 1200));
          openAppSettings();
          throw Exception('Storage permission permanently denied');
        }
      }
    }
    // If SDK version is >= 33 (Android 13+)
    else {
      PermissionStatus filePermission = await Permission.photos.status;

      if (filePermission.isGranted) {
        return await pickImage();
      } else {
        filePermission = await Permission.photos.request();

        if (filePermission.isGranted) {
          return await pickImage();
        } else if (filePermission.isDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_denied,
            );
          }
          throw Exception('Storage permission denied');
        } else if (filePermission.isPermanentlyDenied) {
          if (context.mounted) {
            showErrorToast(
              context,
              AppLocalizations.of(context)!.permission_storage_toast,
            );
          }
          await Future.delayed(Duration(milliseconds: 1200));
          openAppSettings();
          throw Exception('Storage permission permanently denied');
        }
      }
    }
  }
  throw Exception('Unsupported platform');
}
