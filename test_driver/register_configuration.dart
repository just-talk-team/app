import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/layouts/register.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/route_generator.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUserService extends Mock implements UserService {}

void main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AuthenticationService authenticationService = MockAuthenticationService();
  UserService userService = MockUserService();
  when(authenticationService.user).thenAnswer((_) => const Stream.empty());

  final byteData = await rootBundle.load('test_resources/descarga.jpg');
  final file = File('${(await getTemporaryDirectory()).path}/test_image.jpg');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  UserInput userInput = UserInput(
      genre: null,
      dateTime: DateTime.now(),
      nickname: null,
      segments: [],
      imgProfile: file);

  runApp(RepositoryProvider.value(
    value: authenticationService,
    child: BlocProvider(
        create: (_) =>
            AuthenticationCubit(authenticationService: authenticationService),
        child: MaterialApp(
          home: Register(
            initialPage: 0,
            user: userInput,
            userService: userService,
          ),
          onGenerateRoute: RouterGenerator.generateRoute,
          theme: ThemeData(
              primaryColor: Colors.black,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'ArialRounded',
              appBarTheme: AppBarTheme(
                  elevation: 0,
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  textTheme: TextTheme(
                      headline6: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black)))),
        )),
  ));
}
