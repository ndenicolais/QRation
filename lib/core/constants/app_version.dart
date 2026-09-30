// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

/// App version read from the platform build at startup via `package_info_plus`
/// (`main.dart`), so it always matches `version:` in `pubspec.yaml` without a
/// manually maintained constant. Falls back to `'dev'` for code paths that
/// never went through `main()` (e.g. widget tests).
class AppVersion {
  AppVersion._();

  static String current = 'dev';
}
