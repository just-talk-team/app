import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/layouts/preferences_page.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:mockito/mockito.dart';

import 'register_configuration.dart';

void main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AuthenticationService authenticationService = MockAuthenticationService();

  UserService userService = MockUserService();
  when(authenticationService.user).thenAnswer((_) => const Stream.empty());

  runApp(RepositoryProvider.value(
    value: null,
    child: BlocProvider(
      create: (_) =>
          AuthenticationCubit(authenticationService: authenticationService),
      child: MaterialApp(
        home: Preference(),
        theme: ThemeData(
            primaryColor: Colors.black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'ArialRounded',
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: Colors.white,
                iconTheme: IconThemeData(color: Colors.black))),
      ),
    ),
  ));
}
