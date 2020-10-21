import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicsHear extends StatefulWidget {
  @override
  _TopicsHear createState() => _TopicsHear();
}

class _TopicsHear extends State<TopicsHear> with TickerProviderStateMixin {
  AnimationController _controller;
  int levelClock = 6;
  List<String> arrayTest = [
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US'
  ];

  chatReady() {
    return showGeneralDialog(
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
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'ACEPTAR',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  child: Icon(Icons.keyboard_arrow_left,
                      size: 40, color: Color(0xff666666)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  /*RaisedButton(onPressed: () {
                    chatReady();
                    _startClock();
                  }),*/
                  SizedBox(height: 10),
                  Text(
                    '¿Sobre que puedo escuchar?',
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: List<Widget>.generate(arrayTest.length, (int index) {
                  return Chip(
                    label: Text(arrayTest[index]),
                    onDeleted: () {
                      setState(() {
                        arrayTest.removeAt(index);
                      });
                    },
                  );
                }),
              ),
            )),
      ),
    );
  }
}

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
