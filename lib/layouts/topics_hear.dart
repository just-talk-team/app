import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/bloc/discovery_cubit.dart';
import 'package:just_talk/bloc/discovery_state.dart';
import 'package:just_talk/models/topics.dart';
import 'package:just_talk/services/discovery_service.dart';
import 'package:just_talk/services/topics_service.dart';
import 'package:just_talk/services/user_service.dart';

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

  int levelClock = 6;

  List<Topic> topicsToHear;
  List<Topic> checkList;
  Timer _timer;
  String id;

  @override
  void initState() {
    super.initState();
    topicsToHear = [];
    checkList = [];
    id = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    userService = RepositoryProvider.of<UserService>(context);
    topicsService = TopicsService();
    discoveryService = DiscoveryService();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      userService.setTopicsToHear(checkList, id);
      checkList.clear();
    });

    discoveryCubit = DiscoveryCubit(
        discoveryService: discoveryService,
        userId: id,
        userService: userService);

    discoveryCubit.listen((DiscoveryState discoveryState) {
      switch (discoveryState.runtimeType) {
        case DiscoveryFound:
          chatReady();
          _startClock();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void chatReady() {
    showGeneralDialog(
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 200),
        context: context,
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height / 3,
              child: Material(
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
                    GestureDetector(
                      onTap: () {
                        _controller.reset();
                        Navigator.of(context).pop();
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
                        ),
                      ),
                    )
                  ],
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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          color: Color(0xff666666),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '¿Sobre que puedo escuchar?',
          style: TextStyle(
              color: Color(0xff666666),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder(
          future: topicsService.getTopicsToHear(widget.segments),
          builder: (context, AsyncSnapshot<List<Topic>> topics) {
            topicsToHear = topics.data;

            if (topics.hasData) {
              return Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(topicsToHear.length,
                            (int index) {
                          return ActionChip(
                            label: Text(topicsToHear[index].topic),
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

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(),
      textAlign: TextAlign.center,
    );
  }
}
