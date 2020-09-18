import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:just_talk/models/formz/password.dart';
import 'package:just_talk/models/formz/username.dart';
import 'package:just_talk/services/authentication_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({@required AuthenticationService authenticationService})
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(LoginState());

  final AuthenticationService _authenticationService;

  void usernameChanged(String usernameInput) {
    final username = Username.dirty(usernameInput);

    final newState = state.copyWith(
        username: username, status: Formz.validate([username, state.password]));
    emit(newState);
  }

  void passwordChanged(String passwordInput) {
    final password = Password.dirty(passwordInput);

    final newState = state.copyWith(
        password: password, status: Formz.validate([password, state.username]));
    emit(newState);
  }

  void submit() async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationService.logIn(
            username: state.username.value, password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on Exception catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
