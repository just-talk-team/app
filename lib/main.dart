import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/app.dart';
import 'package:just_talk/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App(
    authenticationService: AuthenticationService(),
  ));
}
