import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_talk/app.dart';
import 'package:just_talk/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  await Firebase.initializeApp();
  runApp(App(
    authenticationService: AuthenticationService(),
  ));
}
