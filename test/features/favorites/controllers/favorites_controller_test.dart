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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';
import 'package:qration/features/favorites/controllers/favorites_controller.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

CodeModel _code(String id, CodeSource source, int day) => CodeModel(
      id: id,
      barcode: Barcode(rawValue: 'code $id', type: BarcodeType.text),
      date: DateTime(2026, 1, day),
      source: source,
      isFavorite: true,
    );

void main() {
  late MockCodesRepository repository;
  late StreamController<List<CodeModel>> stream;
  late FavoritesController controller;

  setUp(() {
    Get.testMode = true;
    repository = MockCodesRepository();
    stream = StreamController<List<CodeModel>>();
    when(() => repository.getFavoriteCodesStream())
        .thenAnswer((_) => stream.stream);
    Get.put<CodesRepository>(repository);
    controller = Get.put(FavoritesController());
  });

  tearDown(() async {
    Get.reset();
    await stream.close();
  });

  test('is loading until the first stream event', () async {
    expect(controller.isLoading.value, isTrue);

    stream.add([]);
    await pumpEventQueue();

    expect(controller.isLoading.value, isFalse);
    expect(controller.hasFavorites.value, isFalse);
  });

  test('splits favorites by source, newest first', () async {
    stream.add([
      _code('1', CodeSource.created, 1),
      _code('2', CodeSource.scanned, 2),
      _code('3', CodeSource.created, 3),
    ]);
    await pumpEventQueue();

    expect(controller.hasFavorites.value, isTrue);
    expect(controller.createdCodes.map((c) => c.id), ['3', '1']);
    expect(controller.scannedCodes.map((c) => c.id), ['2']);
  });

  test('follows later stream updates', () async {
    stream.add([_code('1', CodeSource.created, 1)]);
    await pumpEventQueue();
    stream.add([]);
    await pumpEventQueue();

    expect(controller.createdCodes, isEmpty);
    expect(controller.hasFavorites.value, isFalse);
  });

  test('stream errors are exposed and stop loading', () async {
    stream.addError(Exception('boom'));
    await pumpEventQueue();

    expect(controller.error.value, isNotNull);
    expect(controller.isLoading.value, isFalse);
  });

  test('subscribes to the favorites stream only once', () async {
    stream.add([_code('1', CodeSource.created, 1)]);
    await pumpEventQueue();

    verify(() => repository.getFavoriteCodesStream()).called(1);
  });
}
