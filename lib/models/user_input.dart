import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserInput {
  UserInput({
    this.email,
    this.password,
    this.dateTime,
    this.imgProfile,
    this.genre,
    this.nickname,
    this.topics,
  });

  String email;
  String password;
  Timestamp dateTime;
  File imgProfile;
  String genre;
  String nickname;
  List<String> topics;
}
