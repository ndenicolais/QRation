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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_model.dart';

void main() {
  group('CodeModel.toMap / fromMap', () {
    test('round-trips all fields through a map', () {
      final date = DateTime(2026, 3, 1, 9, 0);
      final original = CodeModel(
        id: 'abc123',
        barcode: const Barcode(
            rawValue: 'https://example.com', type: BarcodeType.url),
        date: date,
        isFavorite: true,
        source: CodeSource.created,
        eyeColor: Colors.red,
        eyeRounded: 2,
        moduleColor: Colors.blue,
        moduleRounded: 1,
        notes: 'some notes',
      );

      final map = original.toMap();
      expect(map['id'], 'abc123');
      expect(map['type'], 'url');
      expect(map['content'], 'https://example.com');
      expect(map['isFavorite'], isTrue);
      expect(map['source'], 'created');
      expect(map['notes'], 'some notes');

      final restored = CodeModel.fromMap(map, 'abc123');
      expect(restored.id, 'abc123');
      expect(restored.barcode.rawValue, 'https://example.com');
      expect(restored.barcode.type, BarcodeType.url);
      expect(restored.date, date);
      expect(restored.isFavorite, isTrue);
      expect(restored.source, CodeSource.created);
      expect(restored.eyeColor.toARGB32(), Colors.red.toARGB32());
      expect(restored.eyeRounded, 2);
      expect(restored.moduleColor.toARGB32(), Colors.blue.toARGB32());
      expect(restored.moduleRounded, 1);
      expect(restored.notes, 'some notes');
    });

    test('fromMap prefers the explicit documentId over map["id"]', () {
      final map = {
        'id': 'ignored',
        'type': 'text',
        'content': 'hello',
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'isFavorite': false,
        'source': 'scanned',
      };

      final restored = CodeModel.fromMap(map, 'real-id');
      expect(restored.id, 'real-id');
    });

    test('fromMap falls back to unknown type/source for unrecognized values',
        () {
      final map = {
        'id': 'x',
        'type': 'not-a-real-type',
        'content': 'hello',
        'date': DateTime(2026, 1, 1).toIso8601String(),
        'isFavorite': false,
        'source': 'not-a-real-source',
      };

      final restored = CodeModel.fromMap(map, '');
      expect(restored.barcode.type, BarcodeType.unknown);
      expect(restored.source, CodeSource.unknown);
    });
  });
}
