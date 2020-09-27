import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                TextFormField(
                  controller: etUsername,
                  decoration: InputDecoration(
                      hintText: 'Correo de tu organización',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            //////////////////////////////////////////////////////////////////////////////////
                            widget.userI.topics.add(etUsername.text);
                            /////////////////////////////////////////////////////////////////////////////////
                            etUsername.clear();
                          });
                        },
                        icon: Icon(Icons.send),
                      )),
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
                                  widget.userI.topics.removeAt(index);
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
          'segments': {},
          'genders': {},
        },
        'topics_hear': FieldValue.arrayUnion(userI.topics),
        'user_type': 'premiun'
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      debugPrint("Error");
    }
  }
}
