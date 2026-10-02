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

extension ExtString on String {
  String? nameValidationError(BuildContext context) {
    String message = '';
    if (trim() == '') {
      return message +=
          '\n${AppLocalizations.of(context)?.validator_name_empty}';
    }
    return message.isNotEmpty ? message : null;
  }

  bool isValidName(BuildContext context) {
    return nameValidationError(context) == null;
  }

  String? emailValidationError(BuildContext context) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    String message = '';

    if (!emailRegExp.hasMatch(this)) {
      if (!contains('@')) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_email_missing_special}';
      }

      if (!contains('.')) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_email_missing_dot}';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool isValidEmail(BuildContext context) {
    return emailValidationError(context) == null;
  }

  String? passwordValidationError(BuildContext context) {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[+!@#\><*~]).{8,}$');
    String message = '';

    if (!passwordRegExp.hasMatch(this)) {
      if (!RegExp(r'[A-Z]').hasMatch(this)) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_password_missing_upper}';
      }

      if (!RegExp(r'[a-z]').hasMatch(this)) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_password_missing_lower}';
      }

      if (!RegExp(r'\d').hasMatch(this)) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_password_missing_digit}';
      }

      if (!RegExp(r'[+!@#\><*~]').hasMatch(this)) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_password_missing_special}';
      }

      if (length < 8) {
        message +=
            '\n${AppLocalizations.of(context)?.validator_password_missing_lenght}';
      }
    }

    return message.isNotEmpty ? message : null;
  }

  bool isValidPassword(BuildContext context) {
    return passwordValidationError(context) == null;
  }
}
