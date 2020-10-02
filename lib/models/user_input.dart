import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class UserInput {
  UserInput({
    this.email,
    this.password,
    this.dateTime,
    this.imgProfile,
    this.genre,
    this.nickname,
    this.segments,
  });

  String email;
  String password;
  Timestamp dateTime;
  File imgProfile;
  String genre;
  String nickname;
  List<Tuple2<String, String>> segments;

  @override
  String toString() {
    return "$email - $nickname - $dateTime - $genre";
  }
}
