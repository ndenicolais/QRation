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
import 'package:qration/features/codes/bindings/scanner_binding.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';
import 'package:qration/features/history/controllers/history_controller.dart';
import 'package:qration/features/settings/bindings/settings_binding.dart';

/// Controllers of the Home tabs. The tabs live in Home's IndexedStack rather
/// than in routes of their own, so their controllers follow the Home route:
/// they are removed on logout (`offAllNamed`) and recreated for the next user.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    ScannerBinding().dependencies();
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(() => HistoryController());
    SettingsBinding().dependencies();
  }
}
