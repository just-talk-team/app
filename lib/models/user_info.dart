import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
      @required this.birthdate,
      @required this.id});

  final String nickname;
  final String photo;
  final Preferences preferences;
  final Preferences filters;
  final Gender gender;
  final int age;
  final DateTime birthdate;
  final String id;

  UserInfo.empty()
      : nickname = '',
        photo = '',
        preferences = Preferences.empty(),
        filters = Preferences.empty(),
        gender = Gender.None,
        age = 0,
        birthdate = null,
        id = '';

  UserInfo.fromChange(UserInfoChange userInfoChange)
      : nickname = userInfoChange.nickname,
        photo = userInfoChange.photo,
        preferences = Preferences.fromChange(userInfoChange.preferences),
        filters = Preferences.fromChange(userInfoChange.preferences),
        gender = userInfoChange.gender,
        age = userInfoChange.age,
        birthdate = userInfoChange.birthdate,
        id = userInfoChange.id;
        
  @override
  List<Object> get props => [id];
}

class UserInfoChange {
  String nickname;
  String photo;
  PreferencesChange preferences;
  PreferencesChange filters;
  Gender gender;
  int age;
  DateTime birthdate;
  String id;

  UserInfoChange.fromUserInfo(UserInfo userInfo) {
    this.age = userInfo.age;
    this.nickname = userInfo.nickname;
    this.photo = userInfo.photo;
    this.preferences = PreferencesChange.fromPreference(userInfo.preferences);
    this.gender = userInfo.gender;
    this.birthdate = userInfo.birthdate;
    this.id = userInfo.id;
    this.filters = PreferencesChange.fromPreference(userInfo.filters);
  }
}
