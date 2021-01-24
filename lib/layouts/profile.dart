import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/widgets/badge.dart';

class Profile extends StatefulWidget {
  Profile({String userId, List<String> topics})
      : assert(userId != null),
        _userId = userId,
        _topics = topics;

  final String _userId;
  final List<String> _topics;

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  UserService userService;
  UserInfo userInfo;
  List<String> segments;
  List<Topic> topicsTalk;
  bool loaded;

  @override
  void initState() {
    super.initState();
    loaded = false;
    userService = RepositoryProvider.of<UserService>(context);
    loadData();
  }

  Future<void> loadData() async {
    userInfo = await userService.getUser(widget._userId, false, false);
    segments = await userService.getSegments(widget._userId);
    topicsTalk = await userService.getTopicsTalk(widget._userId);
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Perfil',
            )),
        body: loaded
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                            Text(describeEnum(userInfo.gender),
                                style: Theme.of(context).textTheme.caption),
                            Text("${userInfo.age} años",
                                style: Theme.of(context).textTheme.caption),
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 1.0,
                          children: List<Widget>.generate(segments.length,
                              (int index) {
                            return Chip(label: Text(segments[index]));
                          }),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
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
                              selected: true,
                              selectedColor: Theme.of(context).accentColor,
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
                      child: Container(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: List<Widget>.generate(topicsTalk.length,
                              (int index) {
                            return Chip(
                              label: Text(
                                topicsTalk[index].topic,
                              ),
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      width: 0.5,
                                      color: Colors.black.withOpacity(0.5))),
                              backgroundColor: widget._topics.length > 0 &&
                                      widget._topics
                                          .contains(topicsTalk[index].topic)
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            );
                          }),
                        ),
                      )),
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
