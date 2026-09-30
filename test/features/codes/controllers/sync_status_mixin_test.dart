// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/codes/services/codes_service.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  group('CodesService.syncStatusFrom', () {
    test('server data with nothing pending is synced', () {
      expect(
        CodesService.syncStatusFrom(
            isFromCache: false, hasPendingWrites: false),
        SyncStatus.synced,
      );
    });

    test('cache-only data is offline', () {
      expect(
        CodesService.syncStatusFrom(isFromCache: true, hasPendingWrites: false),
        SyncStatus.offline,
      );
    });

    test('pending writes win over the cache flag', () {
      expect(
        CodesService.syncStatusFrom(isFromCache: true, hasPendingWrites: true),
        SyncStatus.pending,
      );
    });
  });

  // FavoritesController is a real SyncStatusMixin user; testWidgets gives
  // control over the offline grace-period timer.
  group('SyncStatusMixin', () {
    late MockCodesRepository repository;
    late StreamController<SyncStatus> syncStream;
    // Created inside each test so its timer runs in the test's fake-time zone.
    FavoritesController createController() => Get.put(FavoritesController());

    setUp(() {
      Get.testMode = true;
      repository = MockCodesRepository();
      syncStream = StreamController<SyncStatus>();
      when(() => repository.getSyncStatusStream())
          .thenAnswer((_) => syncStream.stream);
      when(() => repository.getFavoriteCodesStream())
          .thenAnswer((_) => const Stream<List<CodeModel>>.empty());
      Get.put<CodesRepository>(repository);
    });

    tearDown(() async {
      Get.reset();
      await syncStream.close();
    });

    testWidgets('offline is shown only after the grace period', (tester) async {
      final controller = createController();
      syncStream.add(SyncStatus.offline);
      await tester.pump();
      expect(controller.syncStatus.value, SyncStatus.synced);

      await tester.pump(const Duration(seconds: 3));
      expect(controller.syncStatus.value, SyncStatus.offline);
    });

    testWidgets('a quick server answer cancels the offline state',
        (tester) async {
      final controller = createController();
      syncStream.add(SyncStatus.offline);
      await tester.pump(const Duration(milliseconds: 500));
      syncStream.add(SyncStatus.synced);
      await tester.pump(const Duration(seconds: 3));

      expect(controller.syncStatus.value, SyncStatus.synced);
    });

    testWidgets('pending writes are shown immediately', (tester) async {
      final controller = createController();
      syncStream.add(SyncStatus.pending);
      await tester.pump();

      expect(controller.syncStatus.value, SyncStatus.pending);
    });

    test('refreshCodes reports success and failure', () async {
      final controller = createController();
      when(() => repository.refreshCodes()).thenAnswer((_) async {});
      expect(await controller.refreshCodes(), isTrue);

      when(() => repository.refreshCodes()).thenThrow(Exception('offline'));
      expect(await controller.refreshCodes(), isFalse);
    });
  });
}
