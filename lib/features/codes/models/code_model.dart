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
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qration/features/codes/models/code_social_model.dart';

class CodeModel {
  String id;
  Barcode barcode;
  DateTime date;
  bool isFavorite;
  CodeSource source;
  Color eyeColor;
  int eyeRounded;
  Color moduleColor;
  int moduleRounded;
  final CodeSocial? socialMedia;
  String? notes;
  String? logoPath;

  CodeModel({
    required this.id,
    required this.barcode,
    required this.date,
    this.isFavorite = false,
    required this.source,
    this.eyeColor = Colors.black,
    this.eyeRounded = 0,
    this.moduleColor = Colors.black,
    this.moduleRounded = 0,
    this.socialMedia,
    this.notes,
    this.logoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': barcode.type.toString().split('.').last,
      'content': barcode.rawValue ?? '',
      'date': date.toIso8601String(),
      'isFavorite': isFavorite,
      'source': source.toString().split('.').last,
      'eyeColor': eyeColor.toARGB32(),
      'eyeRounded': eyeRounded,
      'moduleColor': moduleColor.toARGB32(),
      'moduleRounded': moduleRounded,
      'socialMedia': socialMedia?.name,
      'notes': notes,
      'logoPath': logoPath,
    };
  }

  factory CodeModel.fromMap(Map<String, dynamic> map, String documentId) {
    final barcode = Barcode(
      rawValue: map['content'] ?? '',
      type: BarcodeType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => BarcodeType.unknown,
      ),
    );

    return CodeModel(
      id: documentId.isEmpty ? map['id'] ?? '' : documentId,
      barcode: barcode,
      date: DateTime.parse(map['date']),
      isFavorite: map['isFavorite'] ?? false,
      source: CodeSource.values.firstWhere(
        (e) => e.toString().split('.').last == map['source'],
        orElse: () => CodeSource.unknown,
      ),
      eyeColor: Color(map['eyeColor'] ?? Colors.black.toARGB32()),
      eyeRounded: map['eyeRounded'] ?? 0,
      moduleColor: Color(map['moduleColor'] ?? Colors.black.toARGB32()),
      moduleRounded: map['moduleRounded'] ?? 0,
      socialMedia: map['socialMedia'] != null
          ? CodeSocial(name: map['socialMedia'], url: '', icon: Icons.link)
          : null,
      notes: map['notes'] ?? '',
      logoPath: map['logoPath'],
    );
  }
}

enum CodeSource { scanned, created, unknown }
