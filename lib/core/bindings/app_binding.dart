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
import 'package:qration/core/controllers/scanner_preferences_controller.dart';
import 'package:qration/core/theme/theme_controller.dart';
import 'package:qration/features/auth/controllers/auth_controller.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/codes/services/codes_service.dart';

/// App-wide services, alive for the whole app session.
///
/// Registered from `main()` before `runApp`, because `QrationApp` already
/// reads [ThemeController] while building the first frame. Screen-level
/// controllers are registered by the per-route bindings in `app_pages.dart`.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(ScannerPreferencesController(), permanent: true);
    Get.put<CodesRepository>(CodesService(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
