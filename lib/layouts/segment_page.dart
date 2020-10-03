import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:tuple/tuple.dart';

class SegmentPage extends StatefulWidget {
  final PageController pageController;
  UserInput userI;

  SegmentPage(this.userI, this.pageController);

  @override
  _SegmentPage createState() => _SegmentPage();
}

class _SegmentPage extends State<SegmentPage> {
  TextEditingController etUsername = TextEditingController();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 110, 0, 0),
      child: Column(children: <Widget>[
        FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Segmento',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Text(
            'Sientete seguro y conversa con personas en tu entorno! :)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            controller: etUsername,
            decoration: InputDecoration(
                hintText: 'Correo de tu organización',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    final domain = etUsername.text.split('@')[1];

                    setState(() {
                      widget.userI.segments.add(Tuple2(etUsername.text, domain));
                      etUsername.clear();
                    });
                  },
                  icon: Icon(Icons.send),
                )),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.width / 2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30, 10, 28.0, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: List<Widget>.generate(widget.userI.segments.length,
                    (int index) {
                  return Chip(
                    label: Text(widget.userI.segments[index].item1),
                    onDeleted: () {
                      setState(() {
                        widget.userI.segments.removeAt(index);
                      });
                    },
                  );
                }),
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            color: Color(0xFFb31020),
            padding: EdgeInsets.all(18.0),
            textColor: Colors.white,
            onPressed: () async {
              debugPrint("PASSED TO");
              if (widget.userI.segments.length != 0) {
                await userService.registrateUser(widget.userI, BlocProvider.of<AuthenticationCubit>(context).state.user.id);
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            icon: Icon(Icons.sentiment_satisfied, size: 18),
            label: Text(
              "Finalizar",
              style: TextStyle(fontSize: 25),
            ),
          ),
        )
      ]),
    );
  }
}
