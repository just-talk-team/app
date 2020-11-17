import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/widgets/results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/src/foundation/diagnostics.dart';

class Chat extends StatefulWidget {
  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  SharedPreferences sharedPreferences;
  final auth.FirebaseAuth _auth =
      auth.FirebaseAuth.instance; //Instancia de Firebase
  auth.User _currentUser;

  String userId1 = "";
  String userId2 = "";

  String chatId = "";
  String chatCol = "";
  List<CustomText> messages = [];
  AnimationController _controller;
  int levelClock = 301;
  Stream chatMessages;
  UserInfo userInfo;
  ScrollController _scrollController;

  getChatId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _currentUser = _auth.currentUser;

    chatId = sharedPreferences.getString("roomId");
    chatCol = sharedPreferences.getString("chatCol");
    debugPrint("RoomId : " + chatId);
    debugPrint("chatCol : " + chatCol);
    var str1 = chatId.substring(0, 28);
    var str2 = chatId.substring(29, 57);
    String uid = _currentUser.uid;

    debugPrint("uid : " + uid);
    debugPrint("str1 : " + str1);
    debugPrint("str2 : " + str2);
    if (str1.compareTo(uid) == 0) {
      debugPrint("User is  str1");
      userId1 = str1;
      userId2 = str2;
    } else {
      debugPrint("User is str2");
      userId1 = str2;
      userId2 = str1;
    }
    FirebaseFirestore.instance.collection("users").doc(uid);

    chatMessages = FirebaseFirestore.instance
        .collection(chatCol)
        .doc(chatId)
        .collection("messages")
        .snapshots();

    //Return Current user ===================================================================
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(_currentUser.uid);

    userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        debugPrint("nickname : " + data['nickname']);
        debugPrint("photo : " + data['avatar']);
        DateTime birthdate = data['birthdate'].toDate();
        var formattedDate =
            DateFormat.yMMMd().format(data['birthdate'].toDate());
        int age =
            (birthdate.difference(DateTime.now()).inDays / 365).truncate();

        debugPrint("age : " + age.toString());
        debugPrint("birthday : " + formattedDate);
        debugPrint("uid : " + _currentUser.uid);

        userInfo = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: null,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthdate: data['birthdate'].toDate(),
            filters: null,
            id: _currentUser.uid);
      }
    });

    setState(() {});
  }

  Future<UserInfo> loadUserData() async {
    _currentUser = _auth.currentUser;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(_currentUser.uid);

    await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        debugPrint("nickname : " + data['nickname']);
        debugPrint("photo : " + data['avatar']);
        DateTime birthdate = data['birthdate'].toDate();
        var formattedDate =
            DateFormat.yMMMd().format(data['birthdate'].toDate());
/*
        var year = data['birthdate'].toDate().year;
        var month = data['birthdate'].toDate().month;
        var day = data['birthdate'].toDate().day;

        debugPrint("year : " +
            year.toString() +
            " - " +
            month.toString() +
            " - " +
            day.toString());*/
        int age =
            (birthdate.difference(DateTime.now()).inDays / 365).truncate();

        debugPrint("age : " + age.toString());
        debugPrint("birthday : " + formattedDate);
        debugPrint("uid : " + _currentUser.uid);

        userInfo = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: null,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthdate: data['birthdate'].toDate(),
            filters: null,
            id: _currentUser.uid);
      }
      return userInfo;
    });
    return userInfo;
  }

  void _startClock() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getChatId();
    _startClock();
  }

  Widget chatMessagesList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(chatCol)
            .doc(chatId)
            .collection("messages")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return CustomText(snapshot.data.docs[index].data()["message"],
                    snapshot.data.docs[index].data()["user"], _currentUser.uid);
              });
        });
  }

  leaveChat() {
    return showGeneralDialog(
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height / 3,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Esta seguro que quiere abandonar el chat?',
                        style:
                            TextStyle(color: Color(0xff959595), fontSize: 15),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            finishChat();
                            //Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Text(
                            'ACEPTAR',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Color(0xffff3f82),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Color(0xffff3f82),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  finishChat() {
    return showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return Results();
        });
  }

  sendMessage(text, type) {
    Map<String, dynamic> message = {
      'user': userId1,
      'message': text.toString(),
      'time': DateTime.now().millisecondsSinceEpoch
    };
    FirebaseFirestore.instance
        .collection(chatCol)
        .doc(chatId)
        .collection("messages")
        .add(message);
    messages.add(CustomText(text, type, _currentUser.uid));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: FutureBuilder(
          future: loadUserData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 3)),
                      ],
                      border: Border.all(
                          width: 0.1, color: Colors.black.withOpacity(0.5)),
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(
                          //snapshot.data.nickname,
                          userInfo.photo), fit: BoxFit.fill),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: new Text(
                              userInfo.nickname,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              describeEnum(userInfo.gender),
                              //snapshot.data.gender.toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(' | '),
                            Text(
                              userInfo.age.toString() + " años",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                      ]),
                  Spacer(),
                  Column(
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 30,
                        color: Color(0xffb31049),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                      child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            leaveChat();
                            //finishChat();
                          },
                          child: Icon(Icons.clear_rounded,
                              size: 30, color: Color(0xffb31049)),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 2, color: Color(0xff959595))),
                          child: Countdown(
                            animation: StepTween(
                              begin: levelClock,
                              end: 0,
                            ).animate(_controller),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [chatMessagesList()],
                    ),
                  )))
                ],
              ))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                          child: SingleChildScrollView(
                        reverse: true,
                        child: TextField(
                          maxLength: 140,
                          controller: _messageController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            hintText: 'Escribe aqui el mensaje...',
                          ),
                        ),
                      )),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: ()  {
                          if (_messageController.text.length > 0) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                            sendMessage(_messageController.text, userId1);
                            _messageController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        child: Icon(Icons.send_rounded,
                            size: 30, color: Color(0xffb31049)),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    if (clockTimer.inSeconds.remainder(60).toString() == "0") {}
    //debugPrint("timer : " + clockTimer.inSeconds.remainder(60).toString());
    return Container(
      child: Text(
        "$timerText",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  String text;
  String type;
  //Loaded by sharedPreferences
  String userId;
  CustomText(this.text, this.type, this.userId);
  double maxW;

  @override
  Widget build(BuildContext context) {
    maxW = ((MediaQuery.of(context).size.width) * 0.75).roundToDouble();

    return Row(
      mainAxisAlignment: (this.type != userId)
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: maxW),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 1,
                    color: this.type == userId
                        ? Color(0xff959595)
                        : Color(0xffb3a407))),
            child: Text(
              text,
              style: TextStyle(
                  color: this.type == userId
                      ? Color(0xff959595)
                      : Color(0xffb3a407)),
            )),
      ],
    );
  }
}
