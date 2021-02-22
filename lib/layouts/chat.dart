import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/services/chat_service.dart';
import 'package:just_talk/services/topics_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/widgets/confirm_dialog.dart';
import 'package:just_talk/widgets/message_text.dart';
import 'package:just_talk/widgets/results.dart';
import 'package:just_talk/models/user_info.dart';
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

class _Chat extends State<Chat>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TextEditingController _messageController;

  String userId = "";
  String friendId = "";
  String roomId = "";
  String chatCol = "";

  List<MessageText> messages = [];
  AnimationController _controller;
  int levelClock = 301;

  Stream chatMessages;
  UserInfo userInfo;
  UserInfo friendInfo;

  //==========================
  bool _isFriend = false;
  bool _hasData = false;

  ScrollController _scrollController;

  UserService userService;
  TopicsService topicsService;

  List<String> topics;
  String topicsShow;

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
    //
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
    topics = await topicsService.getChatTopics(userId, friendId);
    topicsShow = topics.join(', ');

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool active = true;
    switch (state) {
      case AppLifecycleState.detached:
        active = false;
        break;
      case AppLifecycleState.inactive:
        active = false;
        break;
      case AppLifecycleState.paused:
        active = false;
        break;
      case AppLifecycleState.resumed:
        active = true;
        break;
      default:
        break;
    }
    setUserState(userId, roomId, chatCol, active);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    setUserState(userId, roomId, chatCol, true);
    topicsShow = '';
    _messageController = TextEditingController();

    _scrollController = ScrollController();
    userService = RepositoryProvider.of<UserService>(context);
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    topicsService = TopicsService();

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
      _controller.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget chatMessagesList() {
    bool selfFlag = true;
    bool friendFlag = true;

    return StreamBuilder(
        stream: chatMessages,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                String senderId = snapshot.data.docs[index].data()["user"];
                BubbleNip nip;

                if (senderId == userId) {
                  if (selfFlag) {
                    selfFlag = false;
                    friendFlag = true;
                    nip = BubbleNip.rightTop;
                  }

                  return Bubble(
                    radius: Radius.circular(10.0),
                    padding:
                        BubbleEdges.symmetric(horizontal: 10, vertical: 10),
                    margin: BubbleEdges.only(top: 10),
                    alignment: Alignment.topRight,
                    nip: nip,
                    color: Colors.black.withOpacity(0.7),
                    child: Text(
                      snapshot.data.docs[index].data()["message"],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (senderId == friendId) {
                  if (friendFlag) {
                    friendFlag = false;
                    selfFlag = true;
                    nip = BubbleNip.leftTop;
                  }

                  return Bubble(
                    radius: Radius.circular(10.0),
                    padding:
                        BubbleEdges.symmetric(horizontal: 10, vertical: 10),
                    margin: BubbleEdges.only(top: 10),
                    alignment: Alignment.topLeft,
                    nip: nip,
                    color: Color(0xffff2424).withOpacity(0.7),
                    child: Text(
                      snapshot.data.docs[index].data()["message"],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return Bubble(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Text(snapshot.data.docs[index].data()["message"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black)),
                  );
                }
              });
        });
  }

  Future<dynamic> leaveChat() async {
    bool result = await showDialog(
        builder: (BuildContext context) {
          return ConfirmDialog(
              color: Theme.of(context).accentColor,
              message: "Esta seguro que quiere abandonar el chat");
        },
        context: context);

    if (result) {
      finishChat();
    }
  }

  Future<dynamic> finishChat() {
    return showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return Results(
              roomId: roomId,
              userId: userId,
              color: Theme.of(context).primaryColor);
        });
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

    return WillPopScope(
      onWillPop: () async {
        if (widget._chatType == ChatType.FriendChat) {
          Navigator.of(context).pop();
          return true;
        }
        return false;
      },
      child: Scaffold(
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
                  onTap: () async {
                    if (_hasData) {
                      Navigator.of(context).pushNamed('/chat_profile',
                          arguments: {'userId': friendId, 'topics': topics});
                    }
                  },
                  child: Row(
                    children: [
                      StreamBuilder(
                          stream: getUserState(friendId, roomId, chatCol),
                          builder: (context, snapshot) {
                            bool aux = snapshot.hasData ? snapshot.data : false;
                            return Container(
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
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: aux ? Colors.green : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friendInfo.nickname,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${describeEnum(friendInfo.gender)} | ${friendInfo.age} años',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'Preguntame sobre: $topicsShow',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                            ]),
                      ),
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
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
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
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    FLog.info(
                                      text: "Finish chat",
                                      methodName: "leaveChat",
                                      className: "Chat",
                                    );
                                    leaveChat();
                                    //finishChat();
                                  },
                                  child: Icon(Icons.clear_rounded,
                                      size: 30,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          width: 2,
                                          color:
                                              Colors.black.withOpacity(0.5))),
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
                        : Container(margin: EdgeInsets.symmetric(vertical: 10)),
                    Expanded(
                        child: roomId != "" ? chatMessagesList() : Container())
                  ],
                ))),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _messageController, //
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Escribe aqui el mensaje...',
                        contentPadding: EdgeInsets.all(10.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send_rounded,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            if (_messageController.text.length > 0) {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              sendMessage(_messageController.text, userId,
                                  roomId, chatCol);
                              _messageController.clear();

                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 400),
                              );
                            }
                          },
                        )),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

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
