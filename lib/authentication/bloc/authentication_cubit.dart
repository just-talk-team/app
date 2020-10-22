import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    try {
      await _authenticationService.logInWithCredentials(
          await _authenticationService.logInWithFacebook());
    } catch (e) {
      log("Authentication error");
    }
  }

  void mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    if (event.user != User.empty) {
      emit(AuthenticationState.authenticated(event.user));
    } else {
      emit(AuthenticationState.unauthenticated());
    }
  }
}
