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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/utils/qr_decoration.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';

class QrPreview extends StatelessWidget {
  const QrPreview({super.key, required this.controller});

  final CodeCreateStandardController controller;

  @override
  Widget build(BuildContext context) {
    final defaultController = controller.controllers['default'];

    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Center(
        child: AnimatedBuilder(
          animation: defaultController ?? Listenable.merge(const []),
          builder: (context, _) {
            return Obx(
              () => PrettyQrView.data(
                data: (defaultController?.text.isEmpty ?? true)
                    ? " "
                    : defaultController!.text,
                errorCorrectLevel: controller.logoPath.value != null
                    ? QrErrorCorrectLevel.H
                    : QrErrorCorrectLevel.M,
                decoration: buildQrDecoration(
                  eyeColor: controller.eyeColor.value,
                  eyeRounded: controller.eyeRounded.value,
                  moduleColor: controller.moduleColor.value,
                  moduleRounded: controller.moduleRounded.value,
                  logoImage: controller.logoPath.value != null
                      ? FileImage(File(controller.logoPath.value!))
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
