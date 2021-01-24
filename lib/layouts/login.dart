import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/utils/custom_icons_icons.dart';
import 'package:just_talk/widgets/half_circle_clipper.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          //alignment: WrapAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 0.0),
                  alignment: Alignment.center,
                  child: AppTitle()),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: CustomHalfCircleClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                  return RaisedButton.icon(
                    key: Key("Facebook Button"),
                    label: Text(
                      "Facebook",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    icon: Icon(
                      CustomIcons.facebook,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        BlocProvider.of<AuthenticationCubit>(context).logWithFacebook(),
                    color: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  );
                }),
              ],
            )
          ],
        ));
  }
}

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Just Talk',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          child: Text(
            'Forma amistades reales de forma segura',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
