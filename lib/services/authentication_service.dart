import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthPackage;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:just_talk/models/user.dart';

class LogInWithFacebookFailure implements Exception {}
class LogOutFailure implements Exception {}


class AuthenticationService {
  AuthenticationService({
    firebaseAuthPackage.FirebaseAuth firebaseAuth,
    FacebookLogin facebookLogin,
  })  : _firebaseAuth =
            firebaseAuth ?? firebaseAuthPackage.FirebaseAuth.instance,
        _facebookLogin = facebookLogin ?? FacebookLogin();

  final firebaseAuthPackage.FirebaseAuth _firebaseAuth;
  final FacebookLogin _facebookLogin;

  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Future<firebaseAuthPackage.AuthCredential> logInWithFacebook() async {
    final result = await _facebookLogin.logIn(customPermissions: ['email']);
    if (result.status != FacebookLoginStatus.Success) {
      return null;
    }
    return firebaseAuthPackage.FacebookAuthProvider.credential(
        result.accessToken.token);
  }

  Future<void> logInWithCredentials(
      firebaseAuthPackage.AuthCredential authCredential) async {
    try {
      await _firebaseAuth.signInWithCredential(authCredential);
      //log(user_result.user.toString());
    } on AssertionError {
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
    return User(id: uid, email: email);
  }
}
