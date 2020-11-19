import 'package:flutter/material.dart';
import 'package:just_talk/services/badges_service.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/widgets/badget.dart';
import 'package:tuple/tuple.dart';

// ignore: must_be_immutable
class Results extends StatelessWidget {
  Results({Key key, String roomId, String userId}) : super(key: key) {
    _roomId = roomId;
    _userId = userId;

    badgeService = BadgeService();
    flags = List.filled(badgets.length, false);
    badgetList = [];

    for (int i = 0; i < badgets.length; ++i) {
      String text = extraBadgets[i].item1;

      if (text.contains(" ")) {
        text = text.replaceAll(" ", "\n");
      } else {
        text = text + "\n";
      }
      badgetList.add(
        Badget(
            selected: false,
            icon: extraBadgets[i].item2,
            text: text,
            valueChanged: (state) {
              flags[i] = true;
            }),
      );
    }
  }

  List<Widget> badgetList;
  List<bool> flags;
  BadgeService badgeService;
  String _roomId;
  String _userId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height,
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Column(
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: badgetList,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: GestureDetector(
                  onTap: () {
                    badgeService.registerBadgets(flags, _roomId, _userId);
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Results2 extends StatelessWidget {
  const Results2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badget(
                      selected: false,
                      icon: Icons.hearing,
                      text: 'Buen\noyente',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.mood,
                      text: 'Buen\nconversador',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.sentiment_very_satisfied_rounded,
                      text: 'Divertido\n',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.arrow_forward,
                      text: 'Omitir\n',
                      valueChanged: (state) {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Results3 extends StatelessWidget {
  const Results3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badget(
                      selected: false,
                      icon: Icons.hearing,
                      text: 'Buen\noyente',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.mood,
                      text: 'Buen\nconversador',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.sentiment_very_satisfied_rounded,
                      text: 'Divertido\n',
                      valueChanged: (state) {}),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badget(
                      selected: false,
                      icon: Icons.star_border,
                      text: 'El\nMejor',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.mood,
                      text: 'Interesante\n',
                      valueChanged: (state) {}),
                  Badget(
                      selected: false,
                      icon: Icons.support_outlined,
                      text: 'Ayudante\n',
                      valueChanged: (state) {}),
                ],
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
  }
}
