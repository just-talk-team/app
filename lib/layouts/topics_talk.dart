import 'package:flushbar/flushbar.dart';
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
  bool loading = false;

  List<Topic> topicsTalk;
  List<Topic> deletedTopics;

  String userId;
  UserService userService;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    userService = RepositoryProvider.of<UserService>(context);
    topicsTalk = [];
    deletedTopics = [];
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    topicsTalkController = TextEditingController();
    textFieldFocusNode = FocusNode();
    loadData();
  }

  void loadData() async {
    topicsTalk =
        await RepositoryProvider.of<UserService>(context).getTopicsTalk(userId);
    setState(() {});
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
          Builder(
            builder: (context) => IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_right),
              color: topicsTalk.length > 0
                  ? Colors.black
                  : Colors.black.withOpacity(0.5),
              onPressed: () async {
                if (topicsTalk.length > 0) {
                  setState(() {
                    loading = true;
                  });
                  await userService.deleteTopicsHear(userId);

                  if (changed) {
                    await userService.setTopicsHear(userId, topicsTalk);
                    if (deletedTopics.length > 0) {
                      await userService.deleteTopicsTalk(userId, deletedTopics);
                    }
                    userService.setTopicsTalk(userId, topicsTalk);
                    deletedTopics.clear();
                  }

                  List<String> segments = await userService.getSegments(userId);

                  await Navigator.of(context)
                      .pushNamed('/topics_to_hear', arguments: {
                    'segments': segments,
                  });

                  setState(() {
                    loading = false;
                  });
                } else {
                  Flushbar(
                    backgroundColor: Color(0xFFB31048),
                    flushbarPosition: FlushbarPosition.TOP,
                    messageText: Text(
                      "Defina al menos un tema de que hablar!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    duration: Duration(seconds: 3),
                  ).show(context);
                }
              },
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: !loading
                  ? Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: List<Widget>.generate(topicsTalk.length,
                                  (int index) {
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
                                    if (!changed) {
                                      changed = true;
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
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            Expanded(
              flex: 1,
              child: Stack(alignment: Alignment.centerRight, children: <Widget>[
                TextField(
                  controller: topicsTalkController,
                  decoration: InputDecoration(
                    hintText: 'Puedo hablar de ...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
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
                      if (!changed) {
                        changed = true;
                      }
                      topicsTalk.add(Topic(
                          topicsTalkController.text.toLowerCase(),
                          DateTime.now()));
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
