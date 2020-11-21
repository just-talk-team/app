import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/layouts/avatar_page.dart';
import 'package:just_talk/layouts/info_page.dart';
import 'package:just_talk/layouts/nickname_page.dart';
import 'package:just_talk/layouts/segment_page.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  Register({initialPage, user, userService})
      : _initialPage = initialPage ?? 0,
        _user = user ??
            UserInput(
                dateTime: DateTime.now(),
                genre: null,
                nickname: null,
                segments: [],
                imgProfile: null),
        _userService = userService ?? UserService();

  final int _initialPage;
  final UserService _userService;
  UserInput _user;

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  DateTime _date = DateTime.now();
  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        print(_date.toString());
      });
    }
  }

  @override
  initState() {
    super.initState();
    controller =
        PageController(viewportFraction: 1, initialPage: widget._initialPage);
  }
  //==============================================

  DateTime bornTime;
  String genre;
  String nickName;
  File imageProfile;
  var topics;
  PageController controller;

  //===================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SmoothPageIndicator(
                    controller: controller,
                    count: 4,
                    effect: JumpingDotEffect(
                        spacing: 12.0,
                        dotWidth: 20.0,
                        dotHeight: 20.0,
                        strokeWidth: 0.2,
                        paintStyle: PaintingStyle.stroke,
                        dotColor: Colors.black,
                        activeDotColor: const Color(0xffb3a507)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: PageView(key: Key("pageview"), controller: controller,
                //physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[
                  InfoPage(widget._user, controller),
                  NicknamePage(widget._user, controller),
                  AvatarPage(widget._user, controller),
                  SegmentPage(widget._user, controller, widget._userService),
                ]),
          ),
        ]),
      ),
    );
  }
}
