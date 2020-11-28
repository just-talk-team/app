import 'package:flutter/material.dart';
import 'package:just_talk/services/badges_service.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/widgets/badge.dart';

// ignore: must_be_immutable
class Results extends StatelessWidget {
  Results({Key key, String roomId, String userId}) : super(key: key) {
    _roomId = roomId;
    _userId = userId;

    badgeService = BadgeService();
    flags = List.filled(badges.length, false);
    badgetList = [];

    for (int i = 0; i < badges.length; ++i) {
      String text = badges[i].item1;

      if (text.contains(" ")) {
        text = text.replaceAll(" ", "\n");
      } else {
        text = text + "\n";
      }

      badgetList.add(Badge(
          selected: false,
          icon: badges[i].item2,
          text: text,
          valueChanged: (state) {
            flags[i] = state;
          }));
    }
  }

  List<Badge> badgetList;
  List<bool> flags;
  BadgeService badgeService;
  String _roomId;
  String _userId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height/3,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
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
                    badgeService.registerBadges(flags, _roomId, _userId);
                    Navigator.of(context).popUntil((route) => (route.settings.name == '/home'));
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

// ignore: must_be_immutable
class Results2 extends StatelessWidget {
  Results2({Key key, String roomId, String userId}) : super(key: key) {
    _roomId = roomId;
    _userId = userId;

    badgeService = BadgeService();
    flags = List.filled(badges.length, false);
    badgetList = [];

    for (int i = 0; i < badges.length; ++i) {
      String text = badges[i].item1;

      if (text.contains(" ")) {
        text = text.replaceAll(" ", "\n");
      } else {
        text = text + "\n";
      }

      badgetList.add(Badge(
          selected: false,
          icon: badges[i].item2,
          text: text,
          valueChanged: (state) {
            flags[i] = state;
          }));
    }
  }

  List<Badge> badgetList;
  List<bool> flags;
  BadgeService badgeService;
  String _roomId;
  String _userId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height / 3,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '¿Como calificaras a tu talker?',
                        style: TextStyle(color: Color(0xffff3f82)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: badgetList
                    ..add(Badge(
                        selectedColor: Color(0xffff3f82),
                        selected: false,
                        icon: Icons.arrow_forward,
                        text: 'Omitir\n',
                        valueChanged: (state) {
                          badgeService.registerBadges(flags, _roomId, _userId);
                          Navigator.pushReplacementNamed(context, '/home');
                        })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Results3 extends StatelessWidget {
  Results3({Key key, String roomId, String userId}) : super(key: key) {
    _roomId = roomId;
    _userId = userId;

    badgeService = BadgeService();
    flags = List.filled(extraBadges.length, false);
    badgetList = [];

    for (int i = 0; i < extraBadges.length; ++i) {
      String text = extraBadges[i].item1;

      if (text.contains(" ")) {
        text = text.replaceAll(" ", "\n");
      } else {
        text = text + "\n";
      }

      badgetList.add(Badge(
          selected: false,
          icon: extraBadges[i].item2,
          text: text,
          valueChanged: (state) {
            flags[i] = state;
          }));
    }
  }

  List<Badge> badgetList;
  List<bool> flags;
  BadgeService badgeService;
  String _roomId;
  String _userId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height / 2.2,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
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
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: badgetList.sublist(0, 3)),
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: badgetList.sublist(3, 6)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: GestureDetector(
                  onTap: () {
                    badgeService.registerBadges(flags, _roomId, _userId);
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
