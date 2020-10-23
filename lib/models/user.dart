import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/utils/enums.dart';

class User extends Equatable {
  const User({
    @required this.id,
    @required this.email,
  })  : assert(id != null),
        assert(email != null);

  final String id;
  final String email;

  static const empty = User(id: '', email: '');

  @override
  List<Object> get props => [id, email];
}
