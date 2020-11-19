import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/services/remote_service.dart';
import 'package:just_talk/widgets/results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:just_talk/models/user_info.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'dart:async';

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
  List<dynamic> uidDynamic = List<dynamic>();

  String userId1 = "";
  String userId2 = "";

  String roomId = "";
  String chatCol = "";
  List<CustomText> messages = [];
  AnimationController _controller;
  int levelClock = 301;
  Stream chatMessages;
  UserInfo yourUserInfo;
  UserInfo userInfo;

  var badgets = [1, 1, 1];

  //==========================
  String _photoUrl = "";
  String _nickname = "";
  String _age = "";
  String _gender = "";
  bool _isFriend = false;
  bool _hasData = false;
  bool _chatReady;

  ScrollController _scrollController;
  RemoteConfig remoteConfig;

  Future recoverChatInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _currentUser = _auth.currentUser;
    String uid = _currentUser.uid;

    roomId = sharedPreferences.getString("roomId");
    chatCol = sharedPreferences.getString("chatCol");

    var str1 = roomId.substring(0, 28);
    var str2 = roomId.substring(29, 57);

    if (str1.compareTo(uid) == 0) {
      userId1 = str1;
      userId2 = str2;
    } else {
      userId1 = str2;
      userId2 = str1;
    }

    List<String> badgets = List<String>();
    //load your data (check if userId its in friendList)====================================================================
    DocumentReference yourUserDoc =
        FirebaseFirestore.instance.collection("users").doc(userId1);

    yourUserDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        DateTime birthdate = data['birthdate'].toDate();

        int age =
            (birthdate.difference(DateTime.now()).inDays / 365).truncate();

        yourUserInfo = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: null,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthdate: data['birthdate'].toDate(),
            filters: null,
            id: userId1);
      } else {}
    });

    debugPrint("Badgets isze; " + badgets.length.toString());
    //Search frieden on user friend list===============================================

    var findFriendOnList = FirebaseFirestore.instance
        .collection("users")
        .doc(userId1)
        .collection("friends")
        .where('roomId', isEqualTo: roomId)
        .get();

    findFriendOnList.then((value) {
      if (value.docs.isNotEmpty) {
        _isFriend = true;
      }
    });

    //Recover message stream==============================================================
    chatMessages = FirebaseFirestore.instance
        .collection(chatCol)
        .doc(roomId)
        .collection("messages")
        .snapshots();

    //Return another user ===================================================================
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(userId2);

    userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        DateTime birthdate = data['birthdate'].toDate();

        int age =
            (DateTime.now().difference(birthdate).inDays / 365).truncate();

        userInfo = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: null,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthdate: data['birthdate'].toDate(),
            filters: null,
            id: userId2);

        if (userInfo.photo != null) _photoUrl = userInfo.photo;
        _gender = describeEnum(userInfo.gender);
        _age = userInfo.age.toString();
        _nickname = userInfo.nickname;

        setState(() {
          _hasData = true;
        });
      }
    });
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
            (DateTime.now().difference(birthdate).inDays / 365).truncate();

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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        leaveChat();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    remoteConfig = RepositoryProvider.of<RemoteService>(context).remoteConfig;
    _chatReady = false;
    recoverChatInfo();
    _startClock();
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  Widget chatMessagesList() {
    _chatReady = true;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(chatCol)
            .doc(roomId)
            .collection("messages")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
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
              width: MediaQuery.of(context).size.width - 120,
              height: MediaQuery.of(context).size.height / 5,
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '¿Esta seguro de que quiere abandonar el chat?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            finishChat();
                            //Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text(
                              'ACEPTAR',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Color(0xffff3f82),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                            child: Text(
                              'CANCELAR',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Color(0xffff3f82),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
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
          return Center(
            child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height / 3,
                child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Builder(builder: (context) {
                      int randomNumber =
                          int.parse(remoteConfig.getString('BadgesView'));

                      print("[RESULTS]: $randomNumber");

                      switch (randomNumber) {
                        case 1:
                          return Results(
                              roomId: roomId, userId: _currentUser.uid);
                        case 2:
                          return Results2(
                              roomId: roomId, userId: _currentUser.uid);
                        case 3:
                          return Results3(
                              roomId: roomId, userId: _currentUser.uid);
                        default:
                          return Results(
                              roomId: roomId, userId: _currentUser.uid);
                      }
                    }))),
          );
        });
  }

  Future<void> sendMessage(text, type) async {
    Map<String, dynamic> message = {
      'user': userId1,
      'message': text.toString(),
      'time': DateTime.now().millisecondsSinceEpoch
    };
    await FirebaseFirestore.instance
        .collection(chatCol)
        .doc(roomId)
        .collection("messages")
        .add(message);

    messages.add(CustomText(text, type, _currentUser.uid));
  }

  addFriend() {
    //Recover elements
    List<dynamic> uidList = List<dynamic>();
    DocumentReference docFriends =
        FirebaseFirestore.instance.collection("friends").doc(roomId);

    //Add select friend to friend collections
    var currentChat = FirebaseFirestore.instance
        .collection("users")
        .doc(userId1)
        .collection("friends")
        .where('roomId', isEqualTo: roomId)
        .get();

    currentChat.then((value) {
      if (value.docs.isNotEmpty) {
        //El valor existe
        docFriends.get().then((value) {
          if (value.exists) {
            var data = value.data();
            uidList = data['friends'];
          }
        });

        uidList.remove(userId1);
        FirebaseFirestore.instance
            .collection("users")
            .doc(userId1)
            .collection("friends")
            .doc(value.docs[0].id)
            .delete();

        FirebaseFirestore.instance
            .collection("friends")
            .doc(roomId)
            .set({"Friends": FieldValue.arrayUnion(uidList)});
        _isFriend = false;
        setState(() {});
      } else {
        //El valor no existe

        docFriends.get().then((value) {
          if (value.exists) {
            var data = value.data();
            uidList = data['friends'];
          }
        });

        uidList.add(userId1);
        FirebaseFirestore.instance
            .collection("users")
            .doc(_currentUser.uid)
            .collection("friends")
            .add({"friend": userId2, "roomId": roomId});

        FirebaseFirestore.instance
            .collection("friends")
            .doc(roomId)
            .set({"friends": FieldValue.arrayUnion(uidList)});
        _isFriend = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () {
      try {
        if (messages.length > 0) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 400));
        }
      } catch (exception) {
        print("Messages empty");
      }
    });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 4,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (BuildContext context) {
            if (_hasData) {
              return Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1.5,
                            blurRadius: 1.5,
                            offset: Offset(0, 3))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(_photoUrl),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          _nickname,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          children: [
                            Text(
                              _gender,
                              //snapshot.data.gender.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(' | '),
                            Text(
                              _age + " años",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                      ]),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    addFriend();
                  },
                  icon: _isFriend
                      ? Icon(Icons.star_rounded)
                      : Icon(Icons.star_border_rounded),
                  iconSize: 30,
                  color: Color(0xffb31049),
                ),
              ],
            ),
          )
        ],
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
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                              EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 2,
                                  color: Colors.black.withOpacity(0.5))),
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
                      child: roomId != "" ? chatMessagesList() : Container())
                ],
              ))),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        height: 50.0,
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            hintText: 'Escribe aqui el mensaje...',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          if (_messageController.text.length > 0) {
                            await sendMessage(_messageController.text, userId1);
                            _messageController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 400),
                            );
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
        style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.5)),
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
