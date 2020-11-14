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

class _TopicsTalk extends State<TopicsTalk> {
  TextEditingController topicsTalkController;

  FocusNode textFieldFocusNode;
  int levelClock = 6;

  List<Topic> topicsTalk;
  List<Topic> deletedTopics;

  String userId;
  UserService userService;
  bool flag;

  @override
  void initState() {
    super.initState();
    userService = RepositoryProvider.of<UserService>(context);
    topicsTalk = [];
    deletedTopics = [];
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    topicsTalkController = TextEditingController();
    textFieldFocusNode = FocusNode();
    flag = false;
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
              if (flag) {
                await userService.setTopicsTalk(userId, topicsTalk);
                await userService.deleteTopicsTalk(userId, deletedTopics);

                await userService.deleteTopicsHear(userId);
                await userService.setTopicsHear(userId, topicsTalk);

                deletedTopics.clear();          
              }
              List<String> segments = await userService.getSegments(userId);
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
                    if (topics.hasData && !flag) {
                      topicsTalk = topics.data;
                    }

                    if (topicsTalk.length > 0) {
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
                                      if (!flag) {
                                        flag = true;
                                      }
                                      setState(() {
                                        deletedTopics.add(topicsTalk[index]);
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

                      if (!flag) {
                        flag = true;
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
