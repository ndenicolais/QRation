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
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

/// State of the Favorites tab: favorite codes split by source.
class FavoritesController extends GetxController {
  final CodesRepository _repository = Get.find<CodesRepository>();
  StreamSubscription<List<CodeModel>>? _subscription;

  final isLoading = true.obs;
  final error = Rxn<Object>();
  final hasFavorites = false.obs;

  /// Newest-first favorites per tab, recomputed only on stream events.
  final createdCodes = <CodeModel>[].obs;
  final scannedCodes = <CodeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.getFavoriteCodesStream().listen(
      (codes) {
        error.value = null;
        hasFavorites.value = codes.isNotEmpty;
        createdCodes.assignAll(bySource(codes, CodeSource.created));
        scannedCodes.assignAll(bySource(codes, CodeSource.scanned));
        isLoading.value = false;
      },
      onError: (Object e) {
        error.value = e;
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  static List<CodeModel> bySource(
      Iterable<CodeModel> codes, CodeSource source) {
    return codes.where((code) => code.source == source).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
