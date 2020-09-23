import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/utils/custom_icons_icons.dart';
import 'package:just_talk/widgets/half_circle_clipper.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          //alignment: WrapAlignment.center,
          children: [
            Positioned(
              top: 450.0,
              child: ClipPath(
                clipper: CustomHalfCircleClipper(),
                child: new Container(
                  height: 400,
                  width: 400,
                  decoration: new BoxDecoration(
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 0.0),
                alignment: Alignment.center,
                child: LoginForm()),
          ],
        ));
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
      return Column(
        children: [
          Text('Just Talk',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'ArialRounded',
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0)),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text(
              'Forma amistades reales de forma segura',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'ArialRounded',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 330.0,
          ),
          SignInButtonBuilder(
            innerPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            icon: CustomIcons.facebook,
            onPressed: () => context.bloc<AuthenticationCubit>().logWithFacebook(),
            backgroundColor: Colors.black,
            text: "Facebook",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            fontSize: 20.0,
          ),
        ],
      );
    });
  }
}
