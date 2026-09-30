// QRation — Copyright © 2026 Nicola De Nicolais — All Rights Reserved.
// Licensed under a source-available, non-commercial license. See LICENSE.
//
// Commercial use, including publishing or monetizing on any app store,
// requires explicit written permission from the copyright holder.
//
// Author: Nicola De Nicolais
// Contact: ndn21dev@gmail.com
// GitHub: https://github.com/ndenicolais

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userEmail;
  final String userName;
  final String? userImage;
  final DateTime userDate;

  UserModel({
    required this.userEmail,
    required this.userName,
    this.userImage,
    DateTime? userDate,
  }) : userDate = userDate ?? DateTime.now();

  Map<String, dynamic> toFirestore() => {
        'userEmail': userEmail,
        'userName': userName,
        'userImage': userImage,
        'userDate': Timestamp.fromDate(userDate),
      };

  factory UserModel.fromFirestore(Map<String, dynamic> data) => UserModel(
        userEmail: data['userEmail'] ?? '',
        userName: data['userName'] ?? '',
        userImage: data['userImage'],
        userDate: data['userDate'] != null
            ? (data['userDate'] as Timestamp).toDate()
            : DateTime.now(),
      );
}
