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

import 'package:get/get.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

/// Sync status and pull-to-refresh for screens listing codes.
///
/// Call [startSyncStatus] from `onInit`; the subscription is cancelled in
/// `onClose`.
mixin SyncStatusMixin on GetxController {
  /// At startup Firestore answers from the local cache before the server
  /// does: wait this long before calling the data "offline" so the banner
  /// doesn't flash on every launch.
  Duration get offlineGracePeriod => const Duration(seconds: 2);

  final syncStatus = SyncStatus.synced.obs;

  StreamSubscription<SyncStatus>? _syncSubscription;
  Timer? _offlineTimer;

  void startSyncStatus(CodesRepository repository) {
    _syncSubscription = repository.getSyncStatusStream().listen(
      _onSyncStatus,
      // A failing status stream must not break the list: just hide the banner.
      onError: (Object _) => syncStatus.value = SyncStatus.synced,
    );
  }

  void _onSyncStatus(SyncStatus status) {
    _offlineTimer?.cancel();
    if (status == SyncStatus.offline) {
      _offlineTimer = Timer(offlineGracePeriod, () {
        syncStatus.value = SyncStatus.offline;
      });
    } else {
      syncStatus.value = status;
    }
  }

  /// Forces a server read. Returns false when the server can't be reached.
  Future<bool> refreshFromServer(CodesRepository repository) async {
    try {
      await repository.refreshCodes();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _offlineTimer?.cancel();
    _syncSubscription?.cancel();
    super.onClose();
  }
}
