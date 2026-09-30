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
import 'package:flutter_test/flutter_test.dart';
import 'package:qration/features/settings/widgets/loading_overlays.dart';

import '../../../support/widget_test_helpers.dart';

void main() {
  testWidgets('LoadingIndicator shows a progress indicator', (tester) async {
    await pumpLocalizedWidget(tester, const LoadingIndicator());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FileLoadingIndicator shows the progress percentage',
      (tester) async {
    await pumpLocalizedWidget(
      tester,
      const FileLoadingIndicator(downloadProgress: 0.42),
    );
    expect(find.text('42%'), findsOneWidget);
  });

  testWidgets('FileLoadingOverlay wraps FileLoadingIndicator', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const FileLoadingOverlay(downloadProgress: 0.75),
    );
    expect(find.byType(FileLoadingIndicator), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
  });

  testWidgets('JsonLoadingOverlay wraps LoadingIndicator', (tester) async {
    await pumpLocalizedWidget(tester, const JsonLoadingOverlay());
    expect(find.byType(LoadingIndicator), findsOneWidget);
  });
}
