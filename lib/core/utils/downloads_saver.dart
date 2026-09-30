// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

const MethodChannel _downloadsChannel =
    MethodChannel('com.ndn21.qration/downloads');

final Logger _logger = Logger();

/// Saves [bytes] as [fileName] into the public Downloads folder, so the
/// user can find the file later from any Files/Downloads app.
///
/// On Android 10+ (API 29+) this uses MediaStore, which requires no runtime
/// permission. On Android 9 and below it requests the storage-write
/// permission first. Best-effort: returns `false` instead of throwing if
/// the platform, permission or native write fails, since the file has
/// already been saved app-side and can still be shared regardless.
Future<bool> saveBytesToPublicDownloads({
  required String fileName,
  required String mimeType,
  required Uint8List bytes,
}) async {
  if (!Platform.isAndroid) return false;

  try {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt < 29) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _logger.e(
            'Storage permission denied, cannot save $fileName to Downloads.');
        return false;
      }
    }

    final result = await _downloadsChannel.invokeMethod<bool>(
      'saveToDownloads',
      {
        'fileName': fileName,
        'mimeType': mimeType,
        'bytes': bytes,
      },
    );
    if (result != true) {
      _logger.e('saveToDownloads returned $result for $fileName.');
    }
    return result ?? false;
  } catch (e) {
    _logger.e('Failed to save $fileName to Downloads: $e');
    return false;
  }
}
