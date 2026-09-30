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
import 'package:qration/features/codes/controllers/scanner_controller.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerController());
  }
}
