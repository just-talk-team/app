import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthPackage;
import 'package:just_talk/models/user.dart';
import 'package:meta/meta.dart';

class LogInWithFacebookFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationService {
  AuthenticationService({firebaseAuthPackage.FirebaseAuth firebaseAuth})
      : _firebaseAuth =
            firebaseAuth ?? firebaseAuthPackage.FirebaseAuth.instance;

  final firebaseAuthPackage.FirebaseAuth _firebaseAuth;

  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Future<void> logInWithFacebook(
      {@required firebaseAuthPackage.AuthCredential authCredential}) async {
    assert(authCredential != null);
    try {
      final result = await _firebaseAuth.signInWithCredential(authCredential);
      log(result.user.toString());
    } on Exception {
      throw LogInWithFacebookFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebaseAuthPackage.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
