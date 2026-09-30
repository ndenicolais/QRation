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
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Lets the user pick an image from the gallery and copies it into a
/// permanent `logos/` subfolder of the app's documents directory, so it
/// survives across app restarts and can be embedded at the center of a
/// generated QR code. Returns the saved file path, or `null` if the user
/// cancelled the picker.
Future<String?> pickAndSaveLogo() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final docsDir = await getApplicationDocumentsDirectory();
  final logosDir = Directory('${docsDir.path}/logos');
  if (!await logosDir.exists()) {
    await logosDir.create(recursive: true);
  }

  final dotIndex = picked.path.lastIndexOf('.');
  final extension = dotIndex == -1 ? '' : picked.path.substring(dotIndex);
  final savedPath =
      '${logosDir.path}/logo_${DateTime.now().millisecondsSinceEpoch}$extension';
  await File(picked.path).copy(savedPath);
  return savedPath;
}
