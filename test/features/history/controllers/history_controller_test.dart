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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/history/controllers/history_controller.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

CodeModel _code(
  String id,
  String rawValue, {
  BarcodeType type = BarcodeType.text,
  CodeSource source = CodeSource.scanned,
  int day = 1,
  String? social,
}) {
  return CodeModel(
    id: id,
    barcode: Barcode(rawValue: rawValue, type: type),
    date: DateTime(2026, 1, day),
    source: source,
    socialMedia: social == null
        ? null
        : CodeSocial(name: social, url: rawValue, icon: Icons.link),
  );
}

void main() {
  final codes = [
    _code('1', 'Hello world', day: 1),
    _code('2', 'https://example.com',
        type: BarcodeType.url, source: CodeSource.created, day: 3),
    _code('3', 'https://instagram.com/me',
        type: BarcodeType.url, day: 2, social: 'Instagram'),
  ];

  group('filterCodes', () {
    test('no filters returns all codes newest first', () {
      final result = HistoryController.filterCodes(codes);
      expect(result.map((c) => c.id), ['2', '3', '1']);
    });

    test('keyword match is case-insensitive', () {
      final result = HistoryController.filterCodes(codes, keyword: 'hello');
      expect(result.map((c) => c.id), ['1']);
    });

    test('standard and social type filters are OR-ed', () {
      final result = HistoryController.filterCodes(
        codes,
        standardTypes: {BarcodeType.text},
        socialTypes: {'Instagram'},
      );
      expect(result.map((c) => c.id), ['3', '1']);
    });

    test('source filter is AND-ed with the type filter', () {
      final result = HistoryController.filterCodes(
        codes,
        standardTypes: {BarcodeType.url},
        source: CodeSource.scanned,
      );
      expect(result.map((c) => c.id), ['3']);
    });
  });

  group('HistoryController', () {
    late MockCodesRepository repository;
    late StreamController<List<CodeModel>> stream;
    late HistoryController controller;

    setUp(() async {
      Get.testMode = true;
      repository = MockCodesRepository();
      stream = StreamController<List<CodeModel>>();
      when(() => repository.getCodesStream()).thenAnswer((_) => stream.stream);
      Get.put<CodesRepository>(repository);
      controller = Get.put(
        HistoryController(searchDebounce: const Duration(milliseconds: 10)),
      );
    });

    tearDown(() async {
      Get.reset();
      await stream.close();
    });

    test('is loading until the first stream event', () async {
      expect(controller.isLoading.value, isTrue);

      stream.add(codes);
      await pumpEventQueue();

      expect(controller.isLoading.value, isFalse);
      expect(controller.filteredCodes.map((c) => c.id), ['2', '3', '1']);
    });

    test('subscribes to the repository stream only once', () async {
      stream.add(codes);
      await pumpEventQueue();
      controller.toggleStandardType(BarcodeType.url);
      controller.onSearchChanged('x');

      verify(() => repository.getCodesStream()).called(1);
    });

    test('stream errors are exposed and stop loading', () async {
      stream.addError(Exception('boom'));
      await pumpEventQueue();

      expect(controller.error.value, isNotNull);
      expect(controller.isLoading.value, isFalse);
    });

    test('search is applied only after the debounce', () async {
      stream.add(codes);
      await pumpEventQueue();

      controller.onSearchChanged('  HELLO ');
      expect(controller.filteredCodes.length, 3);

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(controller.searchKeyword.value, 'hello');
      expect(controller.filteredCodes.map((c) => c.id), ['1']);
    });

    test('clearSearch resets the filter immediately', () async {
      stream.add(codes);
      await pumpEventQueue();
      controller.onSearchChanged('hello');
      await Future<void>.delayed(const Duration(milliseconds: 30));

      controller.clearSearch();

      expect(controller.filteredCodes.length, 3);
    });

    test('type and source filters update the list', () async {
      stream.add(codes);
      await pumpEventQueue();

      controller.toggleStandardType(BarcodeType.url);
      expect(controller.filteredCodes.map((c) => c.id), ['2', '3']);

      controller.setSource(CodeSource.created);
      expect(controller.filteredCodes.map((c) => c.id), ['2']);

      controller.toggleStandardType(BarcodeType.url);
      controller.setSource(null);
      expect(controller.filteredCodes.length, 3);
    });

    test('select all toggles between all filtered and none', () async {
      stream.add(codes);
      await pumpEventQueue();
      controller.startSelection();

      controller.toggleSelectAll();
      expect(controller.selectedIds, {'1', '2', '3'});
      expect(controller.allSelected, isTrue);

      controller.toggleSelectAll();
      expect(controller.selectedIds, isEmpty);
    });

    test('deleteSelected deletes each id and leaves selection mode', () async {
      when(() => repository.deleteCode(any())).thenAnswer((_) async {});
      stream.add(codes);
      await pumpEventQueue();
      controller.startSelection();
      controller.toggleSelected('1');
      controller.toggleSelected('3');

      final deleted = await controller.deleteSelected();

      expect(deleted, 2);
      verify(() => repository.deleteCode('1')).called(1);
      verify(() => repository.deleteCode('3')).called(1);
      expect(controller.isSelecting.value, isFalse);
      expect(controller.selectedIds, isEmpty);
      expect(controller.isDeleting.value, isFalse);
    });

    test('deleteSelected clears the loading flag when deletion fails',
        () async {
      when(() => repository.deleteCode(any())).thenThrow(Exception('fail'));
      controller.startSelection();
      controller.toggleSelected('1');

      await expectLater(controller.deleteSelected(), throwsException);
      expect(controller.isDeleting.value, isFalse);
    });
  });
}
