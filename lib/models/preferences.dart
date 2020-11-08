import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_talk/utils/enums.dart';

class Preferences extends Equatable {
  const Preferences(
      {@required this.maximumAge,
      @required this.minimunAge,
      @required this.genders,
      @required this.segments});

  final int maximumAge;
  final int minimunAge;
  final List<Gender> genders;
  final List<String> segments;

  Preferences.empty()
      : minimunAge = 0,
        maximumAge = 0,
        genders = [],
        segments = [];

  @override
  List<Object> get props => [maximumAge, minimunAge, genders, segments];
}
