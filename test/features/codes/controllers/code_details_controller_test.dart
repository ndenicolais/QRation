// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/controllers/code_details_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

void main() {
  late MockCodesRepository repository;
  late CodeModel code;
  late CodeDetailsController controller;

  setUp(() {
    Get.testMode = true;
    repository = MockCodesRepository();
    Get.put<CodesRepository>(repository);

    code = CodeModel(
      id: 'code-1',
      barcode: const Barcode(rawValue: 'hello', type: BarcodeType.text),
      date: DateTime(2026, 1, 1),
      source: CodeSource.scanned,
      isFavorite: false,
    );
    controller = CodeDetailsController(code);
    controller.onInit();
  });

  tearDown(() {
    Get.reset();
  });

  test('onInit seeds isFavorite from the code model', () {
    expect(controller.isFavorite.value, isFalse);
  });

  test('toggleFavorite flips local state and persists it', () async {
    when(() => repository.toggleFavoriteStatus(any(), any()))
        .thenAnswer((_) async {});

    await controller.toggleFavorite();

    expect(controller.isFavorite.value, isTrue);
    expect(code.isFavorite, isTrue);
    verify(() => repository.toggleFavoriteStatus('code-1', true)).called(1);
  });

  test('updateNotes persists notes and updates the local model', () async {
    when(() => repository.updateCodeNotes(any(), any()))
        .thenAnswer((_) async {});

    await controller.updateNotes('new notes');

    expect(code.notes, 'new notes');
    verify(() => repository.updateCodeNotes('code-1', 'new notes')).called(1);
  });

  test('deleteCode marks the code as deleted after removal', () async {
    when(() => repository.deleteCode(any())).thenAnswer((_) async {});

    await controller.deleteCode();

    expect(controller.isCodeDeleted.value, isTrue);
    verify(() => repository.deleteCode('code-1')).called(1);
  });

  test('toggleExpanded flips isExpanded', () {
    expect(controller.isExpanded.value, isFalse);
    controller.toggleExpanded();
    expect(controller.isExpanded.value, isTrue);
    controller.toggleExpanded();
    expect(controller.isExpanded.value, isFalse);
  });

  test('searchProductOptions builds amazon/ebay/google search urls', () {
    final options = controller.searchProductOptions(
      '8001234567890',
      amazonLabel: 'Amazon',
      ebayLabel: 'eBay',
      googleLabel: 'Google',
    );

    expect(options, hasLength(3));
    expect(options[0].url, 'https://www.amazon.com/s?k=8001234567890');
    expect(
        options[1].url, 'https://www.ebay.com/sch/i.html?_nkw=8001234567890');
    expect(options[2].url, 'https://www.google.com/search?q=8001234567890');
  });

  test('searchBookOptions builds google books/amazon/goodreads search urls',
      () {
    final options = controller.searchBookOptions(
      '9780134685991',
      googleBooksLabel: 'Google Books',
      amazonLabel: 'Amazon',
      goodreadsLabel: 'Goodreads',
    );

    expect(options, hasLength(3));
    expect(
        options[0].url, 'https://books.google.com/books?vid=ISBN9780134685991');
    expect(options[1].url, 'https://www.amazon.com/s?k=9780134685991');
    expect(options[2].url, 'https://www.goodreads.com/search?q=9780134685991');
  });
}
