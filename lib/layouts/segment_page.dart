import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:tuple/tuple.dart';

class SegmentPage extends StatefulWidget {
  final PageController pageController;

  UserService userService;
  UserInput userI;
  SegmentPage(this.userI, this.pageController, this.userService);

  @override
  _SegmentPage createState() => _SegmentPage();
}

class _SegmentPage extends State<SegmentPage> {
  TextEditingController etUsername = TextEditingController();

  bool validateUser(UserInput userInput) {
    for (Tuple2<String, String> segments in userInput.segments) {
      if (!EmailValidator.validate(segments.item1)) {
        return false;
      }
    }

    return ((userInput.nickname != null || userInput.nickname.length > 0) &&
        userInput.genre != null &&
        userInput.imgProfile != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          //Title
          Container(
              child: Column(
            children: <Widget>[
              SizedBox(height: 110),
              Container(
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Segmento',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: AutoSizeText(
                  'Sientete seguro y conversa con personas en tu entorno! :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          )),

          //Content
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          key: Key("Segment input"),
                          controller: etUsername,
                          decoration: InputDecoration(
                            hintText: 'Correo de tu organización',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                        ),
                        IconButton(
                          key: Key("Add segment"),
                          icon: Icon(Icons.send),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            String email = etUsername.text;
                            if (!EmailValidator.validate(email)) {
                              return;
                            }
                            String domain = email.split('@')[1];
                            setState(() {
                              widget.userI.segments.add(Tuple2(email, domain));
                              etUsername.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Container(
                        height: MediaQuery.of(context).size.width / 3,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: List<Widget>.generate(
                                widget.userI.segments.length, (int index) {
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
                  ),
                
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 25,
                          0,
                          MediaQuery.of(context).size.width / 25,
                          0),
                      child: AutoSizeText(
                        '* Una vez validado el correo, deberás validar el mismo ingresando al enlace que enviamos',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff8a8a8a)),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
