import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';

import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/widgets/badge.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.index, this.navbarCubit, this.userService});

  final int index;
  final NavbarCubit navbarCubit;
  final UserService userService;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserInfo userInfo;
  String userId;
  List<String> segments;
  List<Topic> topicsHear;
  bool loaded;

  @override
  void initState() {
    super.initState();
    loaded = false;
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    loadData();
  }

  Future<void> loadData() async {
    try {
      userInfo = await widget.userService.getUser(userId, false, false);
      segments = await widget.userService.getSegments(userId);
      topicsHear = await widget.userService.getTopicsHear(userId);
      setState(() {
        loaded = true;
      });
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi perfil',
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                if (userInfo != null) {
                  bool change = await Navigator.pushNamed(
                      context, '/configuration',
                      arguments: {
                        'userId': BlocProvider.of<AuthenticationCubit>(context)
                            .state
                            .user
                            .id,
                        'userInfo': userInfo,
                        'userService': widget.userService,
                      });

                  if (change) {
                    loadData();
                  }
                }
              }),
        ],
      ),
      body: loaded
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userInfo.photo,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Text(
                              userInfo.nickname,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Text(
                            '${describeEnum(userInfo.gender)} | ${userInfo.age} años',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 1.0,
                        children:
                            List<Widget>.generate(segments.length, (int index) {
                          return Chip(
                            label: Text(segments[index]),
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10.0,
                        children: [
                          Badge(
                            selectedColor: Theme.of(context).accentColor,
                            selected: true,
                            icon: Icons.hearing,
                            text: 'Buen oyente',
                            valueChanged: (state) {},
                            active: false,
                          ),
                          Badge(
                            selectedColor: Theme.of(context).accentColor,
                            selected: true,
                            icon: Icons.mood,
                            text: 'Buen conversador',
                            valueChanged: (state) {},
                            active: false,
                          ),
                          Badge(
                            selectedColor: Theme.of(context).accentColor,
                            selected: true,
                            icon: Icons.sentiment_very_satisfied,
                            text: 'Divertido',
                            valueChanged: (state) {},
                            active: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //TopicsHear
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: List<Widget>.generate(topicsHear.length,
                              (int index) {
                            return Chip(
                              label: Text(
                                topicsHear[index].topic,
                              ),
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 0.5,
                                      color: Colors.black.withOpacity(0.5))),
                              backgroundColor: Colors.transparent,
                            );
                          }),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sentiment_very_satisfied_rounded,
            ),
            label: 'Just Talk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Mi perfil',
          ),
        ],
        currentIndex: widget.index,
        onTap: (index) {
          switch (index) {
            case 0:
              widget.navbarCubit.toHome();
              break;
            case 1:
              widget.navbarCubit.toContacts();
              break;
            case 2:
              widget.navbarCubit.toProfile();
              break;
          }
        },
      ),
    );
  }
}
