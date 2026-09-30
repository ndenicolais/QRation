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

class OnboardingInfo {
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final String description;
  final Color descriptionColor;

  const OnboardingInfo({
    required this.backgroundColor,
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.descriptionColor,
  });
}
