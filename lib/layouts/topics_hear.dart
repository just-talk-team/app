import 'dart:async';

import 'package:badges/badges.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/bloc/discovery_cubit.dart';
import 'package:just_talk/bloc/discovery_state.dart';
import 'package:just_talk/bloc/topic_hear_cubit.dart';
import 'package:just_talk/bloc/topic_hear_state.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/services/discovery_service.dart';
import 'package:just_talk/services/topics_service.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/utils/enums.dart';

class TopicsHear extends StatefulWidget {
  TopicsHear(this.segments);
  final List<String> segments;

  @override
  _TopicsHear createState() => _TopicsHear();
}

class _TopicsHear extends State<TopicsHear> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _topicController;

  UserService userService;
  TopicsService topicsService;
  DiscoveryService discoveryService;
  DiscoveryCubit discoveryCubit;
  TopicHearCubit topicHearCubit;
  final levelClock = 20;
  final topicClock = 10;

  List<Topic> topicsToHear;
  List<Topic> checkList;
  Timer _timer;
  Timer _topicTimer;
  String id;
  bool accept;
  bool visible;

  @override
  void initState() {
    super.initState();
    accept = false;
    visible = true;

    topicsToHear = [];
    checkList = [];

    id = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    userService = RepositoryProvider.of<UserService>(context);
    discoveryService = DiscoveryService();
    initCubit();
    initTimer();
    initTopicAnimation();
  }

  void initTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      List<Topic> aux = List.from(checkList);
      await userService.setTopicsHear(id, aux);
    });
  }

  void initCubit() async {
    topicHearCubit = TopicHearCubit(topicsService: TopicsService());
    topicHearCubit.init(await userService.getSegmentsDomains(id));

    discoveryCubit = DiscoveryCubit(
        discoveryService: discoveryService,
        userId: id,
        userService: userService);

    await discoveryCubit.init();

    discoveryCubit.listen((DiscoveryState discoveryState) {
      switch (discoveryState.runtimeType) {
        case DiscoveryFound:
          String roomId = (discoveryState as DiscoveryFound).room;
          FLog.info(
              className: "TopicsHear",
              methodName: "initCubit",
              text: "Room $roomId found");
          chatReady((discoveryState as DiscoveryFound).room);
          break;
        case DiscoveryReady:
          String roomId = (discoveryState as DiscoveryReady).room;
          _controller.stop();
          Navigator.of(context).pop();
          FLog.info(
              className: "TopicsHear",
              methodName: "initCubit",
              text: "Room $roomId ready");
          Navigator.pushReplacementNamed(context, '/chat', arguments: {
            'roomId': roomId,
            'chatType': ChatType.DiscoveryChat,
          });
          print("Room ID: $roomId");
          break;
        // Send to chat
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _topicController?.stop();
    _topicTimer?.cancel();
    _topicController?.dispose();

    _controller?.stop();
    _controller?.dispose();
    discoveryCubit.close();
    super.dispose();
  }

  void chatReady(String room) {
    _startClock();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 2,
                                    color: Colors.black.withOpacity(0.8))),
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Text(
                        'Sala de chat lista, recuerda ser tu mismo!',
                        style:
                            TextStyle(color: Color(0xff959595), fontSize: 15),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      if (!accept) {
                        return GestureDetector(
                          onTap: () {
                            accept = true;
                            discoveryService.activateUser(room, id);
                            setState(() {});
                          },
                          child: Text(
                            'ACEPTAR',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Container(child: CircularProgressIndicator());
                    })
                  ],
                ),
              ),
            ),
          );
        });
  }

  void initTopicAnimation() {
    _topicController = AnimationController(
        vsync: this, duration: Duration(seconds: topicClock));
    _topicController.forward();
    _topicController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          visible = false;
        });

        _topicTimer = Timer(Duration(milliseconds: 500), () {
          topicHearCubit.shuffle();
          _topicController.reset();
          _topicController.forward();
          setState(() {
            visible = true;
          });
        });
      }
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
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (!accept) {
          Navigator.of(context)
              .popUntil((route) => (route.settings.name == '/home'));
        } else {
          accept = false;
          Navigator.of(context).pop();
          await discoveryCubit.reset();
        }
      }
    });
  }

  List<Topic> getTopics(List<Topic> src, List<Topic> filter) {
    List<Topic> topics = [];
    for (Topic topic in src) {
      if (!filter.contains(topic)) {
        topics.add(topic);
      }
    }
    return topics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.keyboard_arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '¿Sobre que puedo escuchar?',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Color(0xff959595))),
            child: Countdown(
              animation: StepTween(
                begin: topicClock,
                end: 0,
              ).animate(_topicController),
            ),
          ),
        ),
        BlocBuilder<TopicHearCubit, TopicHearState>(
            cubit: topicHearCubit,
            builder: (context, TopicHearState topicHearState) {
              if (topicHearState.runtimeType == TopicHearResult) {
                topicsToHear = getTopics(
                    (topicHearState as TopicHearResult).topics, checkList);
                print(topicsToHear);
              }
              return Expanded(
                child: AnimatedOpacity(
                  opacity: visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(topicsToHear.length,
                            (int index) {
                          return TopicChip(
                              label: topicsToHear[index].topic,
                              callback: () => setState(() {
                                    checkList.add(topicsToHear[index]);
                                  }));
                        }),
                      ),
                    ),
                  ),
                ),
              );
            })
      ]),
    );
  }
}

class TopicChip extends StatelessWidget {
  TopicChip({String label, Function callback})
      : assert(label != null),
        this.label = label,
        this.callback = callback;

  final String label;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          label,
          style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        onPressed: callback);
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

    //print('animation.value  ${animation.value} ');
    //print('inMinutes ${clockTimer.inMinutes.toString()}');
    //print('inSeconds ${clockTimer.inSeconds.toString()}');
    //print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(),
      textAlign: TextAlign.center,
    );
  }
}
