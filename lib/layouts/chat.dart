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
  ScrollController _scrollController;

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
            (birthdate.difference(DateTime.now()).inDays / 365).truncate();

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

        setState(() {});
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
    recoverChatInfo();
    _startClock();
  }

  Widget chatMessagesList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(chatCol)
            .doc(roomId)
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
                          onTap: () {
                            Navigator.pop(context, true);
                          },
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
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height / 3,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.add_alarm,
                          size: 40,
                          color: Color(0xffff3f82),
                        ),
                        Text(
                          '5 min',
                          style: TextStyle(color: Color(0xffff3f82)),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    badgets[0] *= -1;
                                    debugPrint(
                                        "badget 0 : " + badgets[0].toString());
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 2,
                                              color: badgets[0] == 1
                                                  ? Color(0xff959595)
                                                  : Color(0xFFB3A407))),
                                      child: Icon(
                                        Icons.hearing,
                                        size: 30,
                                        color: badgets[0] == 1
                                            ? Color(0xff959595)
                                            : Color(0xFFB3A407),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      width: 70,
                                      child: Text(
                                        'Buen oyente',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: badgets[0] == 1
                                                ? Color(0xff959595)
                                                : Color(0xFFB3A407),
                                            fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // 2=================================================
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    badgets[1] *= -1;
                                    debugPrint(
                                        "badget 1 : " + badgets[1].toString());
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 2,
                                              color: badgets[1] == 1
                                                  ? Color(0xff959595)
                                                  : Color(0xFFB3A407))),
                                      child: Icon(
                                        Icons.mood,
                                        size: 30,
                                        color: badgets[1] == 1
                                            ? Color(0xff959595)
                                            : Color(0xFFB3A407),
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Buen conversador',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: badgets[1] == 1
                                                ? Color(0xff959595)
                                                : Color(0xFFB3A407),
                                            fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // 3===================================================

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    badgets[2] *= -1;
                                    debugPrint(
                                        "badget 2 : " + badgets[2].toString());
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 2,
                                              color: badgets[2] == 1
                                                  ? Color(0xff959595)
                                                  : Color(0xFFB3A407))),
                                      child: Icon(
                                        Icons.sentiment_very_satisfied_rounded,
                                        size: 30,
                                        color: badgets[2] == 1
                                            ? Color(0xff959595)
                                            : Color(0xFFB3A407),
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text('Divertido',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: badgets[2] == 1
                                                  ? Color(0xff959595)
                                                  : Color(0xFFB3A407),
                                              fontSize: 10)),
                                    )
                                  ],
                                ),
                              ),
                              //======================================================
                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text(
                        'FINALIZAR',
                        style: TextStyle(
                            letterSpacing: 2,
                            color: Color(0xffff3f82),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  /*
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
  */

  sendMessage(text, type) {
    Map<String, dynamic> message = {
      'user': userId1,
      'message': text.toString(),
      'time': DateTime.now().millisecondsSinceEpoch
    };
    FirebaseFirestore.instance
        .collection(chatCol)
        .doc(roomId)
        .collection("messages")
        .add(message);
    messages.add(CustomText(text, type, _currentUser.uid));

    setState(() {});
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

    /*
    FirebaseFirestore.instance
        .collection("users")
        .doc(_currentUser.uid)
        .collection("friends")
        .add({"friend": userId2, "roomId": roomId});

    //Add select friend to friend array
    FirebaseFirestore.instance.collection("friends").doc(roomId).set({
      "friends": FieldValue.arrayUnion([userId1])
    });*/
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
          title: Row(
            children: [
              Container(
                child: _photoUrl != ""
                    ? Container(
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
                      )
                    : null,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: new Text(
                      _nickname,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _gender,
                      //snapshot.data.gender.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(' | '),
                    Text(
                      _age + " años",
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
                  GestureDetector(
                    onTap: () {
                      addFriend();
                    },
                    child: _isFriend == true
                        ? Icon(Icons.star, size: 30, color: Color(0xffb31049))
                        : Icon(
                            Icons.star_border,
                            size: 30,
                            color: Color(0xffb31049),
                          ),
                  ),
                ],
              )
            ],
          )),
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
                      children: roomId != "" ? [chatMessagesList()] : [],
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
                        onTap: () {
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
