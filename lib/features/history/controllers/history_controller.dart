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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/controllers/sync_status_mixin.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

/// State and actions of the History tab: code stream, search, type/source
/// filters and multi-selection deletion.
class HistoryController extends GetxController with SyncStatusMixin {
  HistoryController({this.searchDebounce = const Duration(milliseconds: 300)});

  final Duration searchDebounce;
  final CodesRepository _repository = Get.find<CodesRepository>();
  StreamSubscription<List<CodeModel>>? _subscription;
  Worker? _searchWorker;
  Worker? _filtersWorker;

  final _allCodes = <CodeModel>[].obs;
  final isLoading = true.obs;
  final error = Rxn<Object>();

  /// Raw text as typed; [searchKeyword] follows it after [searchDebounce].
  final searchInput = ''.obs;
  final searchKeyword = ''.obs;
  final selectedStandardTypes = <BarcodeType>{}.obs;
  final selectedSocialTypes = <String>{}.obs;
  final selectedSource = Rxn<CodeSource>();

  /// Filtered and date-sorted codes, recomputed only when an input changes.
  final filteredCodes = <CodeModel>[].obs;

  final isSelecting = false.obs;
  final selectedIds = <String>{}.obs;
  final isDeleting = false.obs;

  bool get allSelected =>
      filteredCodes.isNotEmpty && selectedIds.length == filteredCodes.length;

  /// False when the user has no codes at all (as opposed to no matches).
  bool get hasCodes => _allCodes.isNotEmpty;

  /// Number of filters set in the filter sheet (search excluded, since the
  /// search field already shows it).
  int get activeFilterCount =>
      selectedStandardTypes.length +
      selectedSocialTypes.length +
      (selectedSource.value != null ? 1 : 0);

  bool get hasActiveFilters =>
      searchKeyword.value.isNotEmpty ||
      selectedStandardTypes.isNotEmpty ||
      selectedSocialTypes.isNotEmpty ||
      selectedSource.value != null;

  @override
  void onInit() {
    super.onInit();
    _searchWorker = debounce<String>(
      searchInput,
      (value) => searchKeyword.value = value,
      time: searchDebounce,
    );
    _filtersWorker = everAll(
      [
        _allCodes,
        searchKeyword,
        selectedStandardTypes,
        selectedSocialTypes,
        selectedSource,
      ],
      (_) => _refreshFiltered(),
    );
    startSyncStatus(_repository);
    _subscription = _repository.getCodesStream().listen(
      (codes) {
        error.value = null;
        _allCodes.assignAll(codes);
        isLoading.value = false;
      },
      onError: (Object e) {
        error.value = e;
        isLoading.value = false;
      },
    );
  }

  Future<bool> refreshCodes() => refreshFromServer(_repository);

  @override
  void onClose() {
    _subscription?.cancel();
    _searchWorker?.dispose();
    _filtersWorker?.dispose();
    super.onClose();
  }

  void _refreshFiltered() {
    filteredCodes.assignAll(filterCodes(
      _allCodes,
      keyword: searchKeyword.value,
      standardTypes: selectedStandardTypes,
      socialTypes: selectedSocialTypes,
      source: selectedSource.value,
    ));
  }

  /// Pure filtering + newest-first sorting, kept static for unit testing.
  ///
  /// Type filters are OR-ed together (no type selected = all types), then
  /// AND-ed with the search keyword and the source.
  static List<CodeModel> filterCodes(
    Iterable<CodeModel> codes, {
    String keyword = '',
    Set<BarcodeType> standardTypes = const {},
    Set<String> socialTypes = const {},
    CodeSource? source,
  }) {
    final needle = keyword.toLowerCase();
    final noTypeFilter = standardTypes.isEmpty && socialTypes.isEmpty;
    return codes.where((code) {
      final matchesType = noTypeFilter ||
          standardTypes.contains(code.barcode.type) ||
          socialTypes.contains(code.socialMedia?.name);
      final rawValue = code.barcode.rawValue;
      final matchesSearch =
          rawValue != null && rawValue.toLowerCase().contains(needle);
      final matchesSource = source == null || code.source == source;
      return matchesType && matchesSearch && matchesSource;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void onSearchChanged(String value) {
    searchInput.value = value.trim().toLowerCase();
  }

  void clearSearch() {
    searchInput.value = '';
    searchKeyword.value = '';
  }

  void toggleStandardType(BarcodeType type) {
    if (!selectedStandardTypes.remove(type)) selectedStandardTypes.add(type);
  }

  void toggleSocialType(String name) {
    if (!selectedSocialTypes.remove(name)) selectedSocialTypes.add(name);
  }

  void setSource(CodeSource? source) => selectedSource.value = source;

  /// Resets search, type and source filters at once.
  void clearFilters() {
    clearSearch();
    clearSheetFilters();
  }

  /// Resets the filters of the filter sheet, keeping the search.
  void clearSheetFilters() {
    selectedStandardTypes.clear();
    selectedSocialTypes.clear();
    selectedSource.value = null;
  }

  void startSelection() {
    selectedIds.clear();
    isSelecting.value = true;
  }

  void cancelSelection() {
    selectedIds.clear();
    isSelecting.value = false;
  }

  void toggleSelected(String id) {
    if (!selectedIds.remove(id)) selectedIds.add(id);
  }

  void toggleSelectAll() {
    if (allSelected) {
      selectedIds.clear();
    } else {
      selectedIds.addAll(filteredCodes.map((c) => c.id));
    }
  }

  /// Deletes the selected codes and leaves selection mode.
  /// Returns how many codes were deleted.
  Future<int> deleteSelected() async {
    final ids = Set<String>.from(selectedIds);
    isDeleting.value = true;
    try {
      await Future.wait(ids.map(_repository.deleteCode));
    } finally {
      isDeleting.value = false;
    }
    cancelSelection();
    return ids.length;
  }
}
