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

/// The app logo, tinted with the theme's primary color.
///
/// `app_logo.png` is a single-color (navy) mark on a transparent background:
/// drawn as-is it would vanish on the navy surfaces of the dark theme, so it
/// is recolored to the primary color (navy in light, gold in dark, and the
/// accent picked in Settings).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 80, this.color});

  static const assetPath = 'assets/images/app_logo.png';

  final double size;

  /// Overrides the theme primary color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color ?? Theme.of(context).colorScheme.primary,
      colorBlendMode: BlendMode.srcIn,
      semanticLabel: 'QRation',
    );
  }
}
