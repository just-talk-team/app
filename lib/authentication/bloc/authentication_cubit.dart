import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';


class AuthenticationCubit extends Cubit<AuthenticationState> {

  AuthenticationCubit({
    @required AuthenticationService authenticationService,
    @required UserService userService
  }) :  assert(authenticationService != null),
        assert(userService != null),
        _authenticationService = authenticationService,
        _userService = userService,
        super(const AuthenticationState.unknown()){
          _authenticationStatusSubscription = _authenticationService.status.listen(
            (status) => _mapAuthenticationStatusChangedToState(AuthenticationStatusChanged(status))
            ,);
        }


  final AuthenticationService _authenticationService;
  final UserService _userService;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  Future<User> _tryGetUser() async {
    try {
      final user = await _userService.getUser();
      return user;
    } on Exception {
      return null;
    }
  }

   @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationService.dispose();
    return super.close();
  }


  void _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
          emit(AuthenticationState.unauthenticated());
          break;
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();

        if (user != null) {
          emit(AuthenticationState.authenticated(user));
        } else { 
          emit(AuthenticationState.unauthenticated());
        }
        break;
      default:
        emit(AuthenticationState.unknown());
        break;
    }
  }


}