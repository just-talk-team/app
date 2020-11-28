import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_talk/utils/enums.dart';

class Preferences extends Equatable {
  Preferences(
      {@required this.maximumAge,
      @required this.minimunAge,
      @required this.genders,
      @required this.segments,
      @required this.badgets});

  final int maximumAge;
  final int minimunAge;
  final List<Gender> genders;
  final List<String> segments;
  final List<String> badgets;

  Preferences.empty()
      : minimunAge = 18,
        maximumAge = 99,
        genders = [],
        segments = [],
        badgets = [];

   Preferences.fromChange(PreferencesChange preferencesChange)
      : minimunAge = preferencesChange.minimunAge,
        maximumAge = preferencesChange.maximumAge,
        genders = List.from(preferencesChange.genders),
        segments = List.from(preferencesChange.segments),
        badgets = List.from(preferencesChange.badgets);

  @override
  List<Object> get props =>
      [maximumAge, minimunAge, genders, segments, badgets];
}

class PreferencesChange {
  PreferencesChange() {
    minimunAge = 0;
    maximumAge = 0;
    genders = [];
    segments = [];
    badgets = [];
  }

  int maximumAge;
  int minimunAge;
  List<Gender> genders;
  List<String> segments;
  List<String> badgets;

  Preferences toPreference() {
    return Preferences(
        badgets: List.from(badgets),
        maximumAge: maximumAge,
        minimunAge: minimunAge,
        genders: List.from(genders),
        segments: List.from(segments));
  }

  PreferencesChange.fromPreference(Preferences preferences) {
    minimunAge = preferences.minimunAge;
    maximumAge = preferences.maximumAge;
    genders = List.from(preferences.genders);
    segments = List.from(preferences.segments);
    badgets = List.from(preferences.badgets);
  }

  bool compare(Preferences preferences) {
    IterableEquality iterableEquality = IterableEquality();

    return (minimunAge == preferences.minimunAge &&
        maximumAge == preferences.maximumAge &&
        iterableEquality.equals(genders, preferences.genders) &&
        iterableEquality.equals(segments, preferences.segments) &&
        iterableEquality.equals(badgets, preferences.badgets));
  }
}
