import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/utils/enums.dart';


class UserInfo extends Equatable {
  UserInfo(
      {@required this.nickname,
      @required this.photo,
      @required this.preferences,
      @required this.filters,
      @required this.gender,
      @required this.age,
      @required this.birthday,
      @required this.id});

  final String nickname;
  final String photo;
  final Preferences preferences;
  final Preferences filters;
  final Gender gender;
  final int age;
  final DateTime birthday;
  final String id;

  UserInfo.empty()
      : nickname = '',
        photo = '',
        preferences = Preferences.empty(),
        filters = Preferences.empty(),
        gender = Gender.None,
        age = 0,
        birthday = null,
        id ='';

  @override
  List<Object> get props =>[id];
}
