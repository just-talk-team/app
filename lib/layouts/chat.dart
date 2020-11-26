import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/services/remote_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/widgets/custom_text.dart';
import 'package:just_talk/widgets/results.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:just_talk/utils/enums.dart';
import 'dart:async';

class Chat extends StatefulWidget {
  Chat({@required String roomId, @required ChatType chatType})
      : assert(roomId != null),
        assert(chatType != null),
        _roomId = roomId,
        _chatType = chatType;

  final ChatType _chatType;
  final String _roomId;

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();

  String userId = "";
  String friendId = "";
  String roomId = "";
  String chatCol = "";

  List<CustomText> messages = [];
  AnimationController _controller;
  int levelClock = 301;

  Stream chatMessages;
  UserInfo userInfo;
  UserInfo friendInfo;

  //==========================
  bool _isFriend = false;
  bool _hasData = false;

  ScrollController _scrollController;
  RemoteConfig remoteConfig;

  UserService userService;

  Future<void> recoverChatInfo() async {
    roomId = widget._roomId;

    var ids = roomId.split('_');
    if (ids[0] == userId) {
      friendId = ids[1];
    } else {
      friendId = ids[0];
    }

    //load your data (check if userId its in friendList)====================================================================
    userInfo = await userService.getUser(userId, false, false);
    //Search frieden on user friend list===============================================

    var findFriendOnList = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("friends")
        .doc(roomId)
        .get();

    findFriendOnList.then((value) {
      if (value.exists) {
        _isFriend = true;
      }
    });

    //Return another user ===================================================================
    friendInfo = await userService.getUser(friendId, false, false);
    setState(() {
      _hasData = true;
    });
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
    userService = RepositoryProvider.of<UserService>(context);
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;

    if (widget._chatType == ChatType.DiscoveryChat) {
      chatCol = "discoveries";
      _startClock();
    } else {
      chatCol = "friends";
    }
    recoverChatInfo();
  }

  @override
  void dispose() {
    if (widget._chatType == ChatType.DiscoveryChat) {
      _controller.stop();
    }
    super.dispose();
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
          if (snapshot.data == null) return Container();
          return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                String senderId = snapshot.data.docs[index].data()["user"];
                MessageType messageType;

                if (senderId == userId) {
                  messageType = MessageType.CurrentUser;
                } else if (senderId == friendId) {
                  messageType = MessageType.Friend;
                } else {
                  messageType = MessageType.Information;
                }

                return CustomText(
                    snapshot.data.docs[index].data()["message"], messageType);
              });
        });
  }

  Future<dynamic> leaveChat() {
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
                          child: Text(
                            'ACEPTAR',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Color(0xffff3f82),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Color(0xffff3f82),
                                fontSize: 12,
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

  Future<dynamic> finishChat() {
    return showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return Builder(builder: (context) {
            int randomNumber = int.parse(remoteConfig.getString('BadgesView'));

            print("[RESULTS]: $randomNumber");

            switch (randomNumber) {
              case 1:
                return Results(roomId: roomId, userId: userId);
              case 2:
                return Results2(roomId: roomId, userId: userId);
              case 3:
                return Results3(roomId: roomId, userId: userId);
              default:
                return Results(roomId: roomId, userId: userId);
            }
          });
        });
  }

  Future<void> sendMessage(text, type) async {
    Map<String, dynamic> message = {
      'user': userId,
      'message': text.toString(),
      'time': DateTime.now().millisecondsSinceEpoch
    };
    await FirebaseFirestore.instance
        .collection(chatCol)
        .doc(roomId)
        .collection("messages")
        .add(message);
    messages.add(CustomText(text, MessageType.CurrentUser));
  }

  void addFriend() async {
    UserService userService = RepositoryProvider.of<UserService>(context);
    if (!_isFriend) {
      await userService.addFriend(userId, friendId, roomId);
      _isFriend = true;
    } else {
      await userService.deleteFriend(userId, friendId, roomId);
      _isFriend = false;
    }
    setState(() {});
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
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/chat_profile', arguments: {'userId': friendId});
                },
                child: Row(
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
                        backgroundColor: Colors.grey,
                        radius: 25,
                        backgroundImage: NetworkImage(friendInfo.photo),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            friendInfo.nickname,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            children: [
                              Text(
                                describeEnum(friendInfo.gender),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(' | '),
                              Text(
                                friendInfo.age.toString() + " años",
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
                ),
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
                  (widget._chatType == ChatType.DiscoveryChat)
                      ? Container(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 1),
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
                        )
                      : Container(),
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
                            await sendMessage(_messageController.text, userId);
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
