import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/layouts/register.dart';
import 'package:just_talk/services/authentication_service.dart';

void main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AuthenticationService authenticationService = AuthenticationService();

  runApp(RepositoryProvider.value(
    value: authenticationService,
    child: BlocProvider(
        create: (_) =>
            AuthenticationCubit(authenticationService: authenticationService),
        child: MaterialApp(
          home: Register(initialPage: 3,),
          theme: ThemeData(
              primaryColor: Colors.black,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'ArialRounded',
              appBarTheme: AppBarTheme(
                  elevation: 0,
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black))),
        )),
  ));
}
