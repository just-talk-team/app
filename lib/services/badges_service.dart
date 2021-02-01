import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:tuple/tuple.dart';

class BadgeService {
  BadgeService(
      {FirebaseFirestore firebaseFirestore, FirebaseStorage firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {
    _badgets = badges;
  }

  FirebaseFirestore _firebaseFirestore;
  List<Tuple2<String, IconData>> _badgets;

  Future<void> registerBadges(
      List<bool> badgetsFlags, String roomID, String userID) async {
    

    List<String> data = [];

    for (int i = 0; i < badgetsFlags.length; ++i) {
      if (badgetsFlags[i]) {
        data.add(_badgets[i].item1);
      }
    }

    

    if (data.length > 0) {
      await _firebaseFirestore
          .collection('discoveries')
          .doc(roomID)
          .collection('results')
          .doc(userID)
          .set({'badgets': FieldValue.arrayUnion(data)});
    }

    return;
  }
}
