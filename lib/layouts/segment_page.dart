import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:tuple/tuple.dart';
import 'package:flushbar/flushbar.dart';

// ignore: must_be_immutable
class SegmentPage extends StatefulWidget {
  final PageController pageController;

  UserService userService;
  UserInfoChange userI;
  List<String> validSegments;
  SegmentPage(
      this.userI, this.pageController, this.userService, this.validSegments);

  @override
  _SegmentPage createState() => _SegmentPage();
}

class _SegmentPage extends State<SegmentPage> {
  TextEditingController etUsername = TextEditingController();
  bool finished;
  List<Tuple2<String, String>> segments;
  List<String> emails;

  @override
  void initState() {
    super.initState();
    segments = [];
    emails = [];
    finished = false;
  }

  List<String> validateEmail(String email) {
    List<String> aux = etUsername.text.split('@');

    if (widget.validSegments.length > 0 &&
        (!EmailValidator.validate(email) ||
            !widget.validSegments.contains(aux[1]))) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: Text(
          'Correo invalido',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      ).show(context);
      return null;
    }
    return aux;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Title
          Container(
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Segmento',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: AutoSizeText(
              "Descubre amigos de tu organización",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),
          //Content

          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: TextFormField(
              key: Key("Segment input"),
              controller: etUsername,
              decoration: InputDecoration(
                hintText: 'Correo de tu organización',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                suffixIcon: IconButton(
                  key: Key("Add segment"),
                  icon: Icon(Icons.send),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    List<String> email = validateEmail(etUsername.text);
                    if (email == null) {
                      etUsername.clear();
                      return;
                    }

                    setState(() {
                      segments.add(Tuple2(email[0], email[1]));
                      emails.add(etUsername.text);
                      etUsername.clear();
                    });
                  },
                ),
              ),
              onTap: () => setState(() {}),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              '* Correos permitidos: ${widget.validSegments.join(', ')}',
              style: TextStyle(
                color: Color(0xff8a8a8a),
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: List<Widget>.generate(emails.length, (int index) {
                    return Chip(
                      shape: StadiumBorder(
                          side: BorderSide(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.5))),
                      backgroundColor: Colors.transparent,
                      label: Text(emails[index]),
                      deleteIconColor: Theme.of(context).primaryColor,
                      onDeleted: () {
                        setState(() {
                          emails.removeAt(index);
                          segments.removeAt(index);
                        });
                      },
                    );
                  }),
                ),
              )),
          StatefulBuilder(
            builder: (context, setStateInner) => !finished
                ? RaisedButton.icon(
                    key: Key('Finalizar'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (segments.length > 0 && widget.userI.validate()) {
                        setStateInner(() {
                          finished = true;
                        });

                        await widget.userService
                            .registrateUser(widget.userI, segments);
                        await Navigator.of(context)
                            .pushReplacementNamed('/home');
                        setStateInner(() {
                          finished = false;
                        });
                        dispose();
                      }
                    },
                    icon:
                        Icon(Icons.sentiment_very_satisfied_rounded, size: 35),
                    label: Text(
                      "Finalizar",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : CircularProgressIndicator(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.bottomCenter,
            child: AutoSizeText(
              '* Una vez agregado un correo, deberás validar el mismo ingresando al enlace que te enviaremos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff8a8a8a)),
            ),
          )
        ],
      ),
    );
  }
}
