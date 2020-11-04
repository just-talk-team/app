import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
                dateTime: Timestamp.fromDate(DateTime.now()),
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
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(children: <Widget>[
          PageView(key: Key("pageview"), controller: controller,
              //physics: new NeverScrollableScrollPhysics(),
              children: <Widget>[
                //MyInfo(context, controller),
                //Nickname(context),
                InfoPage(widget._user, controller),
                NicknamePage(widget._user, controller),
                AvatarPage(widget._user, controller),
                SegmentPage(widget._user, controller, widget._userService),
              ]),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect: JumpingDotEffect(
                          spacing: 12.0,
                          dotWidth: 20.0,
                          dotHeight: 20.0,
                          strokeWidth: 1.5,
                          paintStyle: PaintingStyle.stroke,
                          dotColor: Colors.black,
                          activeDotColor: const Color(0xffb3a507)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
