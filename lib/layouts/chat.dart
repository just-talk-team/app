import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  List<CustomText> messages = [
    CustomText("Hola como estás?", 1),
    CustomText(
        "An immutable description of how to paint a boxThe BoxDecoration class provides a variety of ways to draw a boxThe box has a border, a body, and may cast a boxShadowThe shape of the box can be a circle or a rectangle. If it is a rectangle, then the borderRadius property controls the roundness of the cornersThe body of the box is painted in layers. The bottom-most layer is the color, which fills the box. Above that is the gradient, which also fills the box. Finally there is the image, the precise alignment of which is controlled by the DecorationImage classhe border paints over the body; the boxShadow, naturally, paints below it.",
        1),
    CustomText("Hola como estás?", 1),
    CustomText("Hola como estás?", 2),
    CustomText("Hola como estás?", 1),
    CustomText("Hola como estás?", 2),
  ];
  AnimationController _controller;
  int levelClock = 301;

  void _startClock() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  sendMessage(text, type) {
    setState(() {
      messages.add(CustomText(text, type));
    });
  }

  leaveChat() {
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
                            Navigator.pushReplacementNamed(context, '/login');
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xff959595))),
                                    child: Icon(
                                      Icons.hearing,
                                      size: 30,
                                      color: Color(0xff959595),
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
                                          color: Color(0xff959595),
                                          fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xff959595))),
                                    child: Icon(
                                      Icons.mood,
                                      size: 30,
                                      color: Color(0xff959595),
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
                                          color: Color(0xff959595),
                                          fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xff959595))),
                                    child: Icon(
                                      Icons.sentiment_very_satisfied,
                                      size: 30,
                                      color: Color(0xff959595),
                                    ),
                                  ),
                                  Container(
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text('Divertido',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Color(0xff959595),
                                              fontSize: 10)))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
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

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
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
                                //leaveChat();
                                //Navigator.pushReplacementNamed(
                                //    context, '/login');
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
                        children:
                            List<Widget>.generate(messages.length, (int index) {
                          return messages[index];
                        }),
                      ),
                    )))
                  ],
                ))),
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      ),
                    ),
                    Container(
                      width: 70,
                      child: GestureDetector(
                        onTap: () {
                          if (_messageController.text != null) {
                            sendMessage(_messageController.text, 1);
                            _messageController.clear();
                          }
                        },
                        child: Icon(Icons.send,
                            size: 30, color: Color(0xffb31049)),
                      ),
                    )
                  ],
                )
              ],
            )));
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

    return Container(
      child: Text(
        "$timerText",
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  String text;
  int type;
  CustomText(this.text, this.type);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width:
              this.type == 1 ? MediaQuery.of(context).size.width / 2 - 50 : 20,
        ),
        Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 2,
                    color: this.type == 1
                        ? Color(0xff959595)
                        : Color(0xffb3a407))),
            child: Text(
              text,
              style: TextStyle(
                  color:
                      this.type == 1 ? Color(0xff959595) : Color(0xffb3a407)),
            ))
      ],
    );
  }
}
