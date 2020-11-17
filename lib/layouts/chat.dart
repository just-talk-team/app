import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/widgets/results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
  //String userId1 = "cejXgSpWtiQnTp3q0nyyJkrapv52", //youId
  //    userId2 = "abChRWzOXXPbDgR1xgxaziZbH652"; //anotherUserId

  String chatId = "";
  String chatCol = "";
  List<CustomText> messages = [];
  AnimationController _controller;
  int levelClock = 301;
  Stream chatMessages;

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
    if (str1 == uid) {
      userId1 = str1;
      userId2 = str2;
    } else {
      userId1 = str2;
      userId2 = str1;
    }
    chatMessages = FirebaseFirestore.instance
        .collection(chatCol)
        .doc(chatId)
        .collection("messages")
        .snapshots();
    setState(() {});
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
    //Crear chat en caso de no existir
    //consultChatRoom();
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
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return CustomText(snapshot.data.docs[index].data()["message"],
                    snapshot.data.docs[index].data()["user"]);
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
                            Navigator.pushReplacementNamed(context, '/home');
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
    messages.add(CustomText(text, type));

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
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      'https://writestylesonline.com/wp-content/uploads/2018/11/Three-Statistics-That-Will-Make-You-Rethink-Your-Professional-Profile-Picture.jpg',
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            Text(
              'Alexa',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Mujer',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  '18 años',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
            Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Icon(
                    Icons.star_border,
                    size: 40,
                    color: Color(0xffb31049),
                  ),
                  Icon(
                    Icons.report,
                    size: 40,
                    color: Color(0xffb31049),
                  )
                ],
              ),
            )
          ],
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
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              finishChat();
                            },
                            child: Icon(Icons.clear,
                                size: 30, color: Color(0xffb31049)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: SingleChildScrollView(
                      reverse: true,
                      child: TextField(
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
                  Container(
                    width: 70,
                    child: GestureDetector(
                      onTap: () {
                        if (_messageController.text.length > 0) {
                          sendMessage(_messageController.text, userId1);
                          _messageController.clear();
                        }
                      },
                      child:
                          Icon(Icons.send, size: 30, color: Color(0xffb31049)),
                    ),
                  )
                ],
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
    debugPrint("timer : " + clockTimer.inSeconds.remainder(60).toString());
    return Container(
      child: Text(
        "$timerText",
        style: TextStyle(fontSize: 22),
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
  String userId = "cejXgSpWtiQnTp3q0nyyJkrapv52";
  CustomText(this.text, this.type);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: this.type == userId
              ? MediaQuery.of(context).size.width / 2 - 50
              : 20,
        ),
        Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 2,
                    color: this.type == userId
                        ? Color(0xff959595)
                        : Color(0xffb3a407))),
            child: Text(
              text,
              style: TextStyle(
                  color: this.type == userId
                      ? Color(0xff959595)
                      : Color(0xffb3a407)),
            ))
      ],
    );
  }
}
