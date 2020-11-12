import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class UserProfile extends Equatable {
  const UserProfile(
      {this.badgets, this.segments, this.topicsHear, this.topicsTalk});
  final List<String> badgets;
  final List<String> segments;
  final List<String> topicsTalk;
  final List<String> topicsHear;

  @override
  List<Object> get props => [badgets, segments, topicsTalk, topicsHear];
}
