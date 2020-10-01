import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/layouts/DashBoard.dart';
import 'package:just_talk/models/UserInput.dart';
import 'package:just_talk/services/authentication_service.dart';

class SegmentPage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
  SegmentPage(this.userI, this.pageController);
  @override
  _SegmentPage createState() => _SegmentPage();
}

class _SegmentPage extends State<SegmentPage> {
  TextEditingController etUsername = new TextEditingController();

  bool get isPopulated => etUsername.text.isNotEmpty;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Card(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 180),
              child: Column(children: <Widget>[
                FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Segmento',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 15),
                Text(
                  'Sientete seguro y conversa con personas en tu entorno! :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: etUsername,
                    decoration: InputDecoration(
                        hintText: 'Correo de tu organización',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              //////////////////////////////////////////////////////////////////////////////////
                              var segment_email = etUsername.text;
                              var arr = segment_email.split('@');
                              if (arr.length > 1) {
                                widget.userI.topics.add(arr[1]);
                                etUsername.clear();
                              } /*else if (segment_email.toLowerCase() ==
                                  "todos") {
                                widget.userI.topics.add(segment_email);
                                etUsername.clear();
                              }*/
                              else {
                                _showSnackbar(context, "Correo no valido");
                              }
                              /////////////////////////////////////////////////////////////////////////////////
                            });
                          },
                          icon: Icon(Icons.send),
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        height: 150,
                        width: 1000,
                        padding: EdgeInsets.fromLTRB(28.0, 10, 28.0, 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: List<Widget>.generate(
                                widget.userI.topics.length, (int index) {
                              return Chip(
                                label: Text(widget.userI.topics[index]),
                                onDeleted: () {
                                  setState(() {
                                    widget.userI.topics.removeAt(index);
                                  });
                                },
                              );
                            }),
                          ),
                        ))),
                SizedBox(height: 45),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  color: Color(0xFFb31020),
                  padding: EdgeInsets.all(18.0),
                  textColor: Colors.white,
                  onPressed: () {
                    debugPrint("PASSED TO");
                    registrateUser(widget.userI);
                  },
                  icon: Icon(Icons.face, size: 18),
                  label: Text(
                    "Finalizar",
                    style: TextStyle(fontSize: 25),
                  ),
                )
              ]),
            )
          ],
        ),
      )),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final scaff = Scaffold.of(context);
    scaff.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: "X",
        onPressed: scaff.hideCurrentSnackBar,
      ),
    ));
  }

  Iterable<int> range(int low, int high) sync* {
    for (int i = low; i < high; ++i) {
      yield i;
    }
  }

  void registrateUser(UserInput userI) async {
    if (widget.userI.topics.length != 0) {
      //Storage
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("UserProfile");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = postImageRef
          .child(timeKey.toString() + ".jpg")
          .putFile(userI.imgProfile);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = imageUrl.toString();

      debugPrint(userI.topics.length.toString());

      await FirebaseFirestore.instance.collection("users").add({
        'uid': BlocProvider.of<AuthenticationCubit>(context).state.user.id,
        'avatar': url,
        'badgets': {'good_talker': 0, 'good_listener': 0, 'funny': 0},
        'birthday': userI.dateTime,
        'friends': {},
        'gender': userI.genre,
        'nickname': userI.nickname,
        'preferences': {
          'ages': {
            'minimun': 18,
            'maximun': 99,
          },
          'segments': FieldValue.arrayUnion(userI.topics),
          'genders': {},
        },
        'topics_hear': {},
        'user_type': 'premiun'
      });

      //Insert segments

      CollectionReference segmentsCollection =
          FirebaseFirestore.instance.collection("segments");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      debugPrint("Error");
    }
  }
}
