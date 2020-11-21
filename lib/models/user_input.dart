import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:tuple/tuple.dart';

class UserInput {
  UserInput({
    this.dateTime,
    this.imgProfile,
    this.genre,
    this.nickname,
    this.segments,
  });

  DateTime dateTime;
  File imgProfile;
  Gender genre;
  String nickname;
  List<Tuple2<String, String>> segments;

  @override
  String toString() {
    return "$nickname - $dateTime - $genre";
  }
}
