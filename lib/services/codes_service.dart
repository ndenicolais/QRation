import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:qration/models/code_model.dart';

class CodesService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  // Function that Codes collection reference for current user
  CollectionReference getCodesCollection() {
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('codes');
  }

  // Function that adds a new Code to Firestore
  Future<void> addCode(CodeModel code) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      DocumentReference docRef = await codesCollection.add(code.toMap());
      code.id = docRef.id;
      await docRef.update({'id': code.id});
    } catch (e) {
      _logger.e('Error adding code: $e');
      throw Exception('Failed to add code: $e');
    }
  }

  // Function that deletes a Code from Firestore
  Future<void> deleteCode(String id) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      await codesCollection.doc(id).delete();
      _logger.i('Code deleted successfully.');
    } catch (e) {
      _logger.e('Error deleting code: $e');
      throw Exception('Failed to delete code: $e');
    }
  }

  // Function that updates the notes of a specific Code
  Future<void> updateCodeNotes(String id, String notes) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      await codesCollection.doc(id).update({'notes': notes});
      _logger.i('Notes updated successfully.');
    } catch (e) {
      _logger.e('Error updating notes: $e');
      throw Exception('Failed to update notes: $e');
    }
  }

  // Function that deletes all Codes from Firestore
  Future<void> deleteAllCodes() async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection.get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      _logger.i('All codes deleted successfully.');
    } catch (e) {
      _logger.e('Error deleting all codes: $e');
      throw Exception('Failed to delete all codes: $e');
    }
  }

  // Function that gets a code based on its ID
  Stream<List<CodeModel>> getCodesStream() {
    try {
      CollectionReference codesCollection = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('codes');

      return codesCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) =>
                CodeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      _logger.e('Error getting codes stream: $e');
      throw Exception('Failed to get codes stream: $e');
    }
  }

  // Function that gets codes favorites list
  Stream<List<CodeModel>> getFavoriteCodesStream() {
    try {
      CollectionReference codesCollection = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('codes');

      return codesCollection
          .where('isFavorite', isEqualTo: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) =>
                CodeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      _logger.e('Error getting favorite codes stream: $e');
      throw Exception('Failed to get favorite codes stream: $e');
    }
  }

  // Function to update code status as favorite
  Future<void> toggleFavoriteStatus(String codeId, bool isFavorite) async {
    {
      try {
        if (currentUser == null) {
          throw "User not logged in";
        }

        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .collection('codes')
            .doc(codeId)
            .update({'isFavorite': isFavorite});

        _logger.i("Favorite state of the code $codeId successfully updated");
      } catch (e) {
        _logger.e("Error updating code favorite status: $e");
      }
    }
  }

  // Function that returns a stream of lists of social codes
  Stream<List<CodeModel>> getSocialCodesStream() {
    try {
      CollectionReference codesCollection = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('codes');

      return codesCollection
          .where('socialMedia', isNotEqualTo: null)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) =>
                CodeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      _logger.e('Error getting social codes stream: $e');
      throw Exception('Failed to get social codes stream: $e');
    }
  }

  // Function that counts all available codes
  Future<int> countAllCodes() async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection.get();

      return querySnapshot.size;
    } catch (e) {
      _logger.e('Error counting all codes: $e');
      throw Exception('Failed to count all codes: $e');
    }
  }

  // Function that counts codes based on their source
  Future<int> countCodesBySource(CodeSource source) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection
          .where('source', isEqualTo: source.toString().split('.').last)
          .get();

      return querySnapshot.size;
    } catch (e) {
      _logger.e('Error counting codes by source: $e');
      throw Exception('Failed to count codes by source: $e');
    }
  }

  // Function that counts codes based on their type
  Future<Map<String, int>> countCodesByType(CodeSource source) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection.get();
      List<CodeModel> codes = querySnapshot.docs
          .map((doc) =>
              CodeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      List<CodeModel> filteredCodes =
          codes.where((code) => code.source == source).toList();
      Map<String, int> codeTypeCounts = {};
      for (var code in filteredCodes) {
        String type = code.barcode.type.toString().split('.').last;
        if (codeTypeCounts.containsKey(type)) {
          codeTypeCounts[type] = (codeTypeCounts[type] ?? 0) + 1;
        } else {
          codeTypeCounts[type] = 1;
        }
      }

      return codeTypeCounts;
    } catch (e) {
      _logger.e('Error counting codes by type: $e');
      throw Exception('Failed to count codes by type: $e');
    }
  }

  // Function that counts social codes based on their type
  Future<Map<String, int>> countSocialCodesByType(CodeSource source) async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection
          .where('socialMedia', isNotEqualTo: null)
          .where('source', isEqualTo: source.toString().split('.').last)
          .get();

      Map<String, int> socialCodesCounts = {};
      for (var doc in querySnapshot.docs) {
        String socialCodeName =
            (doc.data() as Map<String, dynamic>?)?['socialMedia'] ?? '';
        if (socialCodeName.isNotEmpty) {
          if (socialCodesCounts.containsKey(socialCodeName)) {
            socialCodesCounts[socialCodeName] =
                (socialCodesCounts[socialCodeName] ?? 0) + 1;
          } else {
            socialCodesCounts[socialCodeName] = 1;
          }
        }
      }

      return socialCodesCounts;
    } catch (e) {
      _logger.e('Error counting social codes by type: $e');
      throw Exception('Failed to count social codes by type: $e');
    }
  }

  // Export all codes to JSON
  Future<String> exportCodesToJson() async {
    try {
      CollectionReference codesCollection = getCodesCollection();
      QuerySnapshot querySnapshot = await codesCollection.get();
      List<Map<String, dynamic>> codesList = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      String jsonCodes = jsonEncode(codesList);
      _logger.i('Codes exported successfully.');
      return jsonCodes;
    } catch (e) {
      _logger.e('Error exporting codes to JSON: $e');
      throw Exception('Failed to export codes to JSON: $e');
    }
  }

  // Import codes from JSON
  Future<void> importCodesFromJson(String jsonCodes) async {
    try {
      List<dynamic> codesList = jsonDecode(jsonCodes);
      for (var codeMap in codesList) {
        CodeModel code = CodeModel.fromMap(codeMap as Map<String, dynamic>, '');
        await addCode(code);
      }
      _logger.i('Codes imported successfully.');
    } catch (e) {
      _logger.e('Error importing codes from JSON: $e');
      throw Exception('Failed to import codes from JSON: $e');
    }
  }
}
