import 'dart:async';

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
import 'package:logger/logger.dart';

class TopicsHear extends StatefulWidget {
  TopicsHear(this.segments);
  final List<String> segments;

  @override
  _TopicsHear createState() => _TopicsHear();
}

class _TopicsHear extends State<TopicsHear> with TickerProviderStateMixin {
  AnimationController _controller;
  UserService userService;
  TopicsService topicsService;
  DiscoveryService discoveryService;
  DiscoveryCubit discoveryCubit;
  TopicHearCubit topicHearCubit;
  int levelClock = 20;

  List<Topic> topicsToHear;
  List<Topic> checkList;
  Timer _timer;
  String id;
  bool accept;

  Logger logger;

  @override
  void initState() {
    super.initState();
    accept = false;
    topicsToHear = [];
    checkList = [];

    logger = Logger(
      filter: null, // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );

    id = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    userService = RepositoryProvider.of<UserService>(context);
    discoveryService = DiscoveryService();
    initCubit();
    initTimer();
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
          chatReady((discoveryState as DiscoveryFound).room);
          _startClock();
          break;
        case DiscoveryReady:
          _controller.stop();
          Navigator.of(context).pop();
          
          String roomId = (discoveryState as DiscoveryReady).room;
          logger.i("Stream $roomId");
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
  void dispose() async {
    super.dispose();
    _timer.cancel();
    await discoveryCubit.close();
  }

  void chatReady(String room) {
    showGeneralDialog(
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height / 3,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
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
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
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
                              //_controller.stop();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'ACEPTAR',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      color: Color(0xffff3f82),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                          );
                        }
                        return Container(child: CircularProgressIndicator());
                      })
                    ],
                  ),
                ),
              ),
            ),
          );
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
        body: ListView(
          children: [
            BlocBuilder<TopicHearCubit, TopicHearState>(
                cubit: topicHearCubit,
                builder: (context, TopicHearState topicHearState) {
                  if (topicHearState.runtimeType == TopicHearResult) {
                    topicsToHear = getTopics(
                        (topicHearState as TopicHearResult).topics, checkList);
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: List<Widget>.generate(
                                  topicsToHear.length, (int index) {
                                return ActionChip(
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                          width: 0.5,
                                          color:
                                              Colors.black.withOpacity(0.5))),
                                  backgroundColor: Colors.transparent,
                                  label: Text(
                                    topicsToHear[index].topic,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      checkList.add(topicsToHear[index]);
                                    });
                                  },
                                );
                              }),
                            ),
                          )),
                    );
                  }
                  return Container();
                }),
          ],
        ));
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
