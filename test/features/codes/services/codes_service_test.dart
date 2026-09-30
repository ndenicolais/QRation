// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_model.dart';
import 'package:qration/features/codes/services/codes_service.dart';

CodeModel _codeWith({
  required BarcodeType type,
  required CodeSource source,
  bool isFavorite = false,
  String? notes,
}) {
  return CodeModel(
    id: '',
    barcode: Barcode(rawValue: 'value', type: type),
    date: DateTime(2026, 1, 1),
    source: source,
    isFavorite: isFavorite,
    notes: notes,
  );
}

void main() {
  late FakeFirebaseFirestore firestore;
  late MockUser user;
  late MockFirebaseAuth auth;
  late CodesService service;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    user = MockUser(uid: 'user-1', email: 'user@example.com');
    auth = MockFirebaseAuth(mockUser: user, signedIn: true);
    service = CodesService(firestore: firestore, auth: auth);
  });

  test('addCode writes the code under the current user and sets its id',
      () async {
    final code = _codeWith(type: BarcodeType.text, source: CodeSource.created);

    await service.addCode(code);

    expect(code.id, isNotEmpty);
    final snapshot = await firestore
        .collection('users')
        .doc('user-1')
        .collection('codes')
        .doc(code.id)
        .get();
    expect(snapshot.exists, isTrue);
    expect(snapshot.data()!['id'], code.id);
  });

  test('deleteCode removes the document', () async {
    final code = _codeWith(type: BarcodeType.text, source: CodeSource.created);
    await service.addCode(code);

    await service.deleteCode(code.id);

    final snapshot = await firestore
        .collection('users')
        .doc('user-1')
        .collection('codes')
        .doc(code.id)
        .get();
    expect(snapshot.exists, isFalse);
  });

  test('updateCodeNotes persists the new notes', () async {
    final code = _codeWith(type: BarcodeType.text, source: CodeSource.created);
    await service.addCode(code);

    await service.updateCodeNotes(code.id, 'updated notes');

    final snapshot = await firestore
        .collection('users')
        .doc('user-1')
        .collection('codes')
        .doc(code.id)
        .get();
    expect(snapshot.data()!['notes'], 'updated notes');
  });

  test('toggleFavoriteStatus flips the isFavorite flag', () async {
    final code = _codeWith(type: BarcodeType.text, source: CodeSource.created);
    await service.addCode(code);

    await service.toggleFavoriteStatus(code.id, true);

    final snapshot = await firestore
        .collection('users')
        .doc('user-1')
        .collection('codes')
        .doc(code.id)
        .get();
    expect(snapshot.data()!['isFavorite'], isTrue);
  });

  test(
      'countAllCodes / countCodesBySource count only the current user\'s codes',
      () async {
    await service
        .addCode(_codeWith(type: BarcodeType.text, source: CodeSource.created));
    await service
        .addCode(_codeWith(type: BarcodeType.url, source: CodeSource.scanned));
    await service
        .addCode(_codeWith(type: BarcodeType.text, source: CodeSource.created));

    expect(await service.countAllCodes(), 3);
    expect(await service.countCodesBySource(CodeSource.created), 2);
    expect(await service.countCodesBySource(CodeSource.scanned), 1);
  });

  test('countCodesByType groups by barcode type for the given source',
      () async {
    await service
        .addCode(_codeWith(type: BarcodeType.text, source: CodeSource.created));
    await service
        .addCode(_codeWith(type: BarcodeType.text, source: CodeSource.created));
    await service
        .addCode(_codeWith(type: BarcodeType.url, source: CodeSource.created));
    await service
        .addCode(_codeWith(type: BarcodeType.text, source: CodeSource.scanned));

    final counts = await service.countCodesByType(CodeSource.created);
    expect(counts, {'text': 2, 'url': 1});
  });

  test('exportCodesToJson / importCodesFromJson round-trip through JSON',
      () async {
    await service.addCode(
      _codeWith(
          type: BarcodeType.text, source: CodeSource.created, notes: 'hi'),
    );

    final json = await service.exportCodesToJson();

    final freshFirestore = FakeFirebaseFirestore();
    final freshService = CodesService(firestore: freshFirestore, auth: auth);
    await freshService.importCodesFromJson(json);

    expect(await freshService.countAllCodes(), 1);
  });

  test('toggleFavoriteStatus swallows errors when no user is signed in',
      () async {
    final signedOutAuth = MockFirebaseAuth(signedIn: false);
    final signedOutService =
        CodesService(firestore: firestore, auth: signedOutAuth);

    await signedOutService.toggleFavoriteStatus('any-id', true);
  });
}
