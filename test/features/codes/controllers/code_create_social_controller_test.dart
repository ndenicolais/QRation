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
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qration/features/codes/controllers/code_create_social_controller.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/models/code_social_model.dart';
import 'package:qration/features/codes/services/codes_repository.dart';

class MockCodesRepository extends Mock implements CodesRepository {}

class FakeCodeModel extends Fake implements CodeModel {}

CodeSocial _social(String name, String url) =>
    CodeSocial(name: name, url: url, icon: Icons.link);

void main() {
  late MockCodesRepository repository;

  setUpAll(() => registerFallbackValue(FakeCodeModel()));

  setUp(() {
    Get.testMode = true;
    repository = MockCodesRepository();
    Get.put<CodesRepository>(repository);
  });

  tearDown(Get.reset);

  CodeCreateSocialController create(CodeSocial social) =>
      Get.put(CodeCreateSocialController(socialMedia: social));

  test('initial URL is prefilled only for Spotify and WhatsApp', () {
    expect(
      CodeCreateSocialController.initialUrlFor('https://open.spotify.com/'),
      'https://open.spotify.com/',
    );
    expect(
      CodeCreateSocialController.initialUrlFor('https://www.whatsapp.com/'),
      'https://wa.me/',
    );
    expect(
      CodeCreateSocialController.initialUrlFor('https://www.instagram.com/'),
      '',
    );
  });

  test('generic social uses the trimmed URL', () {
    final controller =
        create(_social('Instagram', 'https://www.instagram.com/'));
    controller.urlController.text = '  https://www.instagram.com/me  ';

    expect(controller.buildContent(), 'https://www.instagram.com/me');
  });

  test('Spotify builds a search URI from artist and song', () {
    final controller = create(_social('Spotify', 'https://open.spotify.com/'));
    controller.spotifyArtistController.text = ' Queen ';
    controller.spotifySongController.text = 'Bohemian Rhapsody';

    expect(controller.buildContent(), 'spotify:search:Queen;Bohemian Rhapsody');
  });

  test('WhatsApp combines prefix and number, empty when missing', () {
    final controller = create(_social('WhatsApp', 'https://www.whatsapp.com/'));
    expect(controller.buildContent(), '');

    controller.selectedPrefix.value = '+44';
    controller.whatsappController.text = '7700900123';
    expect(controller.buildContent(), 'https://wa.me/+447700900123');
  });

  test('hasContent reflects any filled field', () {
    final controller =
        create(_social('Instagram', 'https://www.instagram.com/'));
    expect(controller.hasContent(), isFalse);

    controller.urlController.text = 'x';
    expect(controller.hasContent(), isTrue);
  });

  test('createQrCode saves a styled URL code with the social media', () async {
    when(() => repository.addCode(any())).thenAnswer((_) async {});
    final social = _social('Instagram', 'https://www.instagram.com/');
    final controller = create(social);
    controller.eyeColor.value = Colors.red;
    controller.moduleRounded.value = 1;

    final ok = await controller.createQrCode('https://www.instagram.com/me');

    expect(ok, isTrue);
    final code = controller.lastCreatedCode!;
    expect(code.barcode.rawValue, 'https://www.instagram.com/me');
    expect(code.barcode.type, BarcodeType.url);
    expect(code.source, CodeSource.created);
    expect(code.socialMedia, same(social));
    expect(code.eyeColor, Colors.red);
    expect(code.moduleRounded, 1);
    expect(controller.isLoading.value, isFalse);
  });

  test('createQrCode reports failures', () async {
    when(() => repository.addCode(any())).thenThrow(Exception('offline'));
    final controller =
        create(_social('Instagram', 'https://www.instagram.com/'));

    final ok = await controller.createQrCode('https://www.instagram.com/me');

    expect(ok, isFalse);
    expect(controller.lastError, isNotNull);
    expect(controller.isLoading.value, isFalse);
  });
}
