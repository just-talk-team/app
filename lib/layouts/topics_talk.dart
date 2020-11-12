import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/services/user_service.dart';

class TopicsTalk extends StatefulWidget {
  @override
  _TopicsTalk createState() => _TopicsTalk();
}

class _TopicsTalk extends State<TopicsTalk> with TickerProviderStateMixin {
  TextEditingController topicsTalkController;

  FocusNode textFieldFocusNode;
  int levelClock = 6;

  List<Topic> topicsTalk;
  List<Topic> topicsTalkRemoved;
  String userId;
  UserService userService;

  void joinList(List<Topic> topicsTalk, List<Topic> topicsFirestore,
      List<Topic> topicsTalkRemoved) {
    for (Topic topic in topicsFirestore) {
      if (!topicsTalk.contains(topic) && !topicsTalkRemoved.contains(topic)) {
        topicsTalk.add(topic);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userService = RepositoryProvider.of<UserService>(context);
    topicsTalk = [];
    topicsTalkRemoved = [];
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    topicsTalkController = TextEditingController();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    topicsTalkController.dispose();
    textFieldFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.keyboard_arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.keyboard_arrow_right),
            color: topicsTalk.length > 0
                ? Colors.black
                : Colors.black.withOpacity(0.5),
            onPressed: () async {
              await userService.deleteTopicsTalk(userId, topicsTalkRemoved);
              await userService.setTopicsTalk(userId, topicsTalk);
              List<Topic> topics = await userService.getTopicsHear(userId);
              await userService.deleteTopicsHear(userId, topics);
              await userService.setTopicsHear(userId, topicsTalk);
              List<String> segments = await userService.getSegments(userId);
              topicsTalkRemoved.clear();
              topicsTalk.clear();
              Navigator.of(context).pushNamed('/topics_to_hear', arguments: {
                'segments': segments,
              });
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          '¿De qué puedo hablar?',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: FutureBuilder(
                  future: RepositoryProvider.of<UserService>(context)
                      .getTopicsTalk(userId),
                  builder: (context, AsyncSnapshot<List<Topic>> topics) {
                    if (topics.data != null) {
                      joinList(topicsTalk, topics.data, topicsTalkRemoved);
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: List<Widget>.generate(
                                    topicsTalk.length, (int index) {
                                  return Chip(
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            width: 0.5,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    backgroundColor: Colors.transparent,
                                    label: Text(
                                      topicsTalk[index].topic,
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.normal),
                                    ),
                                    deleteIconColor: Color(0xFFB31048),
                                    onDeleted: () {
                                      setState(() {
                                        topicsTalkRemoved
                                            .add(topicsTalk[index]);
                                        topicsTalk.removeAt(index);
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
            ),
            Expanded(
              flex: 1,
              child: Stack(alignment: Alignment.centerRight, children: <Widget>[
                TextFormField(
                  controller: topicsTalkController,
                  focusNode: textFieldFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Puedo hablar de ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      if (topicsTalkController.text.isEmpty) {
                        return;
                      }
                      topicsTalk.add(
                          Topic(topicsTalkController.text, DateTime.now()));
                      topicsTalkController.clear();
                    });
                  },
                )
              ]),
            ),
          ],
        ),
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
