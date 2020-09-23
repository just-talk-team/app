import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthPackage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({@required AuthenticationService authenticationService})
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationService.user.listen((user) =>
        _mapAuthenticationUserChangedToState(AuthenticationUserChanged(user)));
  }

  final AuthenticationService _authenticationService;
  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void logOut() {
    _authenticationService.logOut().then((value) => log("Logout"));
  }

  void logWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(customPermissions: ['email']);
    if (result.status != FacebookLoginStatus.Success) {
      return;
    }

    final firebaseAuthPackage.AuthCredential credential =
        firebaseAuthPackage.FacebookAuthProvider.credential(
            result.accessToken.token);
    await _authenticationService.logInWithFacebook(authCredential: credential);
  }

  void _mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    if (event.user != User.empty) {
      emit(AuthenticationState.authenticated(event.user));
    } else {
      emit(AuthenticationState.unauthenticated());
    }
  }
}
