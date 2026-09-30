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
import 'package:pretty_qr_code/pretty_qr_code.dart';

/// Builds a [PrettyQrDecoration] from the QR eye/module color and
/// shape (square/circle) fields stored on a code, mirroring the previous
/// `qr_flutter` `eyeStyle`/`dataModuleStyle` split.
///
/// [logoImage], when provided, is embedded at the center of the QR code
/// at a conservative scale so the error-correction level (M) can still
/// recover the covered modules.
///
/// [quietZone] defaults to the standard 4-module margin: without it,
/// `pretty_qr_code` draws modules edge-to-edge, and decoders (including
/// `mobile_scanner`'s `analyzeImage`) can fail to even locate the finder
/// patterns once the QR is captured/saved as a standalone image.
PrettyQrDecoration buildQrDecoration({
  required Color eyeColor,
  required int eyeRounded,
  required Color moduleColor,
  required int moduleRounded,
  ImageProvider? logoImage,
}) {
  final moduleShape = moduleRounded == 1
      ? PrettyQrDotsSymbol(color: moduleColor)
      : PrettyQrSquaresSymbol(color: moduleColor);

  final eyeShape = eyeRounded == 1
      ? PrettyQrDotsSymbol(color: eyeColor)
      : PrettyQrSquaresSymbol(color: eyeColor);

  return PrettyQrDecoration(
    background: Colors.white,
    quietZone: PrettyQrQuietZone.standard,
    shape: PrettyQrShape.custom(moduleShape, finderPattern: eyeShape),
    image: logoImage != null
        ? PrettyQrDecorationImage(image: logoImage, scale: 0.2)
        : null,
  );
}
