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
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qration/core/utils/qr_decoration.dart';

void main() {
  group('buildQrDecoration + offscreen QR export (PDF export path)', () {
    // Mirrors the exact rendering call used by PdfService._addCodePage to
    // embed a code's QR image in the exported PDF.
    Future<ui.Image> renderQrImage({
      required String data,
      required Color eyeColor,
      required int eyeRounded,
      required Color moduleColor,
      required int moduleRounded,
    }) async {
      final qrCode = QrCode.fromData(
        data: data,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      );

      final bytes = await QrImage(qrCode).toImageAsBytes(
        size: 220,
        format: ui.ImageByteFormat.png,
        decoration: buildQrDecoration(
          eyeColor: eyeColor,
          eyeRounded: eyeRounded,
          moduleColor: moduleColor,
          moduleRounded: moduleRounded,
        ),
      );

      expect(bytes, isNotNull);

      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(
        bytes!.buffer.asUint8List(),
        completer.complete,
      );
      return completer.future;
    }

    for (final eyeRounded in [0, 1]) {
      for (final moduleRounded in [0, 1]) {
        test(
          'renders a valid 220x220 PNG for eyeRounded=$eyeRounded, '
          'moduleRounded=$moduleRounded',
          () async {
            final image = await renderQrImage(
              data: 'https://example.com/qration-test',
              eyeColor: Colors.black,
              eyeRounded: eyeRounded,
              moduleColor: Colors.blue,
              moduleRounded: moduleRounded,
            );

            expect(image.width, 220);
            expect(image.height, 220);
          },
        );
      }
    }

    test('handles empty/whitespace data without throwing', () async {
      final image = await renderQrImage(
        data: ' ',
        eyeColor: Colors.black,
        eyeRounded: 0,
        moduleColor: Colors.black,
        moduleRounded: 0,
      );

      expect(image.width, 220);
      expect(image.height, 220);
    });

    test('buildQrDecoration maps square/circle fields to the expected shapes',
        () {
      final decoration = buildQrDecoration(
        eyeColor: Colors.red,
        eyeRounded: 1,
        moduleColor: Colors.green,
        moduleRounded: 0,
      );

      // ignore: experimental_member_use
      final shape = decoration.shape as PrettyQrCustomShape;
      expect(shape.shape, isA<PrettyQrSquaresSymbol>());
      expect((shape.shape as PrettyQrSquaresSymbol).color, Colors.green);
      expect(shape.finderPattern, isA<PrettyQrDotsSymbol>());
      expect((shape.finderPattern as PrettyQrDotsSymbol).color, Colors.red);
    });
  });
}
