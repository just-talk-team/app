import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthPackage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({@required AuthenticationService authenticationService})
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationService.user.listen((user) =>
        mapAuthenticationUserChangedToState(AuthenticationUserChanged(user)));
  }

  final AuthenticationService _authenticationService;
  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void logOut() {
    unawaited(_authenticationService.logOut());
  }

  void logWithFacebook() async {
    await _authenticationService.logInWithCredentials(await _authenticationService.logInWithFacebook());
  }

  void mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    if (event.user != User.empty) {
      emit(AuthenticationState.authenticated(event.user));
    } else {
      emit(AuthenticationState.unauthenticated());
    }
  }
}
