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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/theme/app_radius.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/core/widgets/section_card.dart';
import 'package:qration/features/codes/controllers/qr_style_mixin.dart';
import 'package:qration/l10n/app_localizations.dart';

/// Live preview of the QR code being created, used by both the standard and
/// the social creation screens.
///
/// Rebuilds when [contentListenable] (the form's text fields) notifies or
/// when an observable read by [data] or [style] changes.
class QrPreview extends StatelessWidget {
  const QrPreview({
    super.key,
    required this.style,
    required this.contentListenable,
    required this.data,
  });

  final QrStyleMixin style;
  final Listenable contentListenable;

  /// Current QR content; empty while the form is incomplete.
  final String Function() data;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLocalizations.of(context)!.code_create_preview_title,
      icon: MingCuteIcons.mgc_qrcode_fill,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: contentListenable,
              builder: (context, _) => Obx(() {
                final content = data();
                final logoPath = style.logoPath.value;
                return PrettyQrView.data(
                  // A blank space still renders a valid placeholder code.
                  data: content.isEmpty ? ' ' : content,
                  errorCorrectLevel: logoPath != null
                      ? QrErrorCorrectLevel.H
                      : QrErrorCorrectLevel.M,
                  decoration: buildQrDecoration(
                    eyeColor: style.eyeColor.value,
                    eyeRounded: style.eyeRounded.value,
                    moduleColor: style.moduleColor.value,
                    moduleRounded: style.moduleRounded.value,
                    logoImage:
                        logoPath != null ? FileImage(File(logoPath)) : null,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
