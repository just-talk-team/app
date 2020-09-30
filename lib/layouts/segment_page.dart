import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/models/user_input.dart';

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
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 110, 0,0),
      child: Column(children: <Widget>[
        FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Segmento',
              style:
                  TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
            onPressed: () {
              debugPrint("PASSED TO");
              registrateUser(widget.userI);
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
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      debugPrint("Error");
    }
  }
}
