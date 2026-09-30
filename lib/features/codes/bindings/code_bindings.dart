// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/controllers/code_create_social_controller.dart';
import 'package:qration/features/codes/controllers/code_create_standard_controller.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';

// These routes receive their subject as `Get.arguments`. When it is missing
// or of the wrong type the GetPage falls back to HomeScreen, so the bindings
// register nothing instead of failing on the cast.

class CodeCreateStandardBinding extends Bindings {
  @override
  void dependencies() {
    final type = Get.arguments;
    if (type is BarcodeType) {
      Get.lazyPut(() => CodeCreateStandardController(type: type));
    }
  }
}

class CodeCreateSocialBinding extends Bindings {
  @override
  void dependencies() {
    final social = Get.arguments;
    if (social is CodeSocial) {
      Get.lazyPut(() => CodeCreateSocialController(socialMedia: social));
    }
  }
}

class CodeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final code = Get.arguments;
    if (code is CodeModel) {
      Get.lazyPut(() => CodeDetailsController(code));
    }
  }
}
