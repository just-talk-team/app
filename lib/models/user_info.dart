import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/utils/enums.dart';

class UserInfo extends Equatable {
  UserInfo(
      {@required this.nickname,
      @required this.photo,
      @required this.preferences,
      @required this.filters,
      @required this.gender,
      @required this.birthdate,
      @required this.id});

  final String nickname;
  final String photo;
  final Preferences preferences;
  final Preferences filters;
  final Gender gender;
  final DateTime birthdate;
  final String id;

  UserInfo.empty()
      : nickname = '',
        photo = '',
        preferences = Preferences.empty(),
        filters = Preferences.empty(),
        gender = Gender.None,
        birthdate = null,
        id = '';

  UserInfo.fromChange(UserInfoChange userInfoChange)
      : nickname = userInfoChange.nickname,
        photo = null,
        preferences = Preferences.fromChange(userInfoChange.preferences),
        filters = Preferences.fromChange(userInfoChange.preferences),
        gender = userInfoChange.gender,
        birthdate = userInfoChange.birthdate,
        id = userInfoChange.id;

  @override
  List<Object> get props => [id];

  int get age => (DateTime.now().difference(birthdate).inDays / 365).truncate();
}

class UserInfoChange {
  String nickname;
  File photo;
  PreferencesChange preferences;
  PreferencesChange filters;
  Gender gender;
  DateTime birthdate;
  String id;

  UserInfoChange.defaultUser() {
    this.nickname = null;
    this.photo = null;
    this.preferences = null;
    this.gender = null;
    this.birthdate = DateTime.now();
    this.id = null;
    this.filters = null;
  }

  UserInfoChange.fromUserInfo(UserInfo userInfo) {
    this.nickname = userInfo.nickname;
    this.preferences = PreferencesChange.fromPreference(userInfo.preferences);
    this.gender = userInfo.gender;
    this.birthdate = userInfo.birthdate;
    this.id = userInfo.id;
    this.filters = PreferencesChange.fromPreference(userInfo.filters);
  }

  int get age => (DateTime.now().difference(birthdate).inDays / 365).truncate();
  
  bool validate() {
    return (nickname != null &&
        photo != null &&
        gender != null &&
        age >= MIN_AGE &&
        id != null);
  }
}
