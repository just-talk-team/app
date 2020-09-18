import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_talk/app.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';


void main() {
  runApp(App(
    authenticationService: AuthenticationService(),
    userService: UserService(),
  ));
}




