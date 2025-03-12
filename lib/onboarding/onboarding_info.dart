import 'package:flutter/material.dart';

class OnboardingInfo {
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final String description;
  final Color descriptionColor;

  OnboardingInfo({
    required this.backgroundColor,
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.descriptionColor,
  });
}
