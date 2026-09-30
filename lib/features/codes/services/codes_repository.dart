// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:qration/features/codes/models/code_model.dart';

/// Domain-facing contract for code persistence, independent of the backend
/// (Firestore today) that implements it. Screens depend on this abstraction
/// via `Get.find<CodesRepository>()` instead of instantiating a concrete
/// Firestore-backed service directly, so the implementation can be swapped
/// or mocked (e.g. in tests) without touching UI code.
abstract class CodesRepository {
  Future<void> addCode(CodeModel code);
  Future<void> deleteCode(String id);
  Future<void> updateCodeNotes(String id, String notes);
  Future<void> deleteAllCodes();
  Stream<List<CodeModel>> getCodesStream();
  Stream<List<CodeModel>> getFavoriteCodesStream();
  Future<void> toggleFavoriteStatus(String codeId, bool isFavorite);
  Stream<List<CodeModel>> getSocialCodesStream();
  Future<int> countAllCodes();
  Future<int> countCodesBySource(CodeSource source);
  Future<Map<String, int>> countCodesByType(CodeSource source);
  Future<Map<String, int>> countSocialCodesByType(CodeSource source);
  Future<String> exportCodesToJson();
  Future<void> importCodesFromJson(String jsonCodes);
}
