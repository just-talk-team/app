import 'dart:async';

import 'package:just_talk/models/user.dart';
import 'package:uuid/uuid.dart';


class UserService {
  User _user;

  Future<User> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = User(Uuid().v4()),
    );
  }
}
