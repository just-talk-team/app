import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/models/user_profile.dart';
import 'package:just_talk/services/user_service.dart';

class Profile extends StatefulWidget {
  Profile(this.userId);
  final String userId;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfile userProfile;
  UserInfo userInfo;

  List<String> topicsHear = [
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

  Future<bool> getUser(BuildContext context) async {
    UserService userService = UserService();
    userInfo = await userService.getUser(widget.userId, false, false);
    userProfile = await userService.getUserInfoProfile(widget.userId);
    if (userInfo != null && userProfile != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi perfil',
        ),
        actions: <Widget>[],
      ),
      body: FutureBuilder(
          future: getUser(context),
          builder: (context, AsyncSnapshot<bool> flagInfo) {
          

            if (flagInfo.hasData && flagInfo.data) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
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
                              Text(describeEnum(userInfo.gender),
                                  style: Theme.of(context).textTheme.caption),
                              Text("${userInfo.age} años",
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: List<Widget>.generate(userProfile.segments.length,
                                (int index) {
                              return Chip(
                                label: Text(userProfile.segments[index]),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
                                    child: Icon(
                                      Icons.hearing,
                                      size: 30,
                                      color: Color(0xffb3a407),
                                    ),
                                  ),
                                  AutoSizeText(
                                    'Buen oyente',
                                    maxLines: 2,
                                    style: TextStyle(color: Color(0xffb3a407)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
                                    child: Icon(
                                      Icons.mood,
                                      size: 30,
                                      color: Color(0xffb3a407),
                                    ),
                                  ),
                                  AutoSizeText(
                                    'Buen conversador',
                                    maxLines: 2,
                                    style: TextStyle(color: Color(0xffb3a407)),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
                                    child: Icon(
                                      Icons.sentiment_very_satisfied,
                                      size: 30,
                                      color: Color(0xffb3a407),
                                    ),
                                  ),
                                  AutoSizeText('Divertido',
                                      maxLines: 2,
                                      style:
                                          TextStyle(color: Color(0xffb3a407)))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                    //TopicsHear
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: List<Widget>.generate(userProfile.topicsHear.length,
                                  (int index) {
                                return Chip(
                                  label: Text(userProfile.topicsHear[index]),
                                );
                              }),
                            ),
                          )),
                    )
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
