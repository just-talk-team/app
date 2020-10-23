import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/utils/enums.dart';

class UserInfo extends Equatable {
  const UserInfo(
      {@required this.nickname,
      @required this.photo,
      @required this.preferences,
      @required this.gender,
      @required this.age,
      @required this.birthday});

  final String nickname;
  final String photo;
  final Preferences preferences;
  final Gender gender;
  final int age;
  final DateTime birthday;

  static const empty = UserInfo(
      gender: null, nickname: null, preferences: null, photo: null, age: null, birthday: null);

  @override
  List<Object> get props => [nickname, photo, preferences, gender, age, birthday];
}
