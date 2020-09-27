import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/layouts/info_Page.dart';
import 'package:just_talk/models/UserInput.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final controller = PageController(viewportFraction: 1);
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

  //==============================================

  DateTime bornTime;
  String genre;
  String nickName;
  File imageProfile;
  var topics;

  var userI = UserInput(
      dateTime: null,
      genre: null,
      nickname: null,
      topics: [],
      imgProfile: null);

  //===================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Stack(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView(controller: controller,
                //physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[
                  //MyInfo(context, controller),
                  //Nickname(context),
                  InfoPage(userI, controller),
                ]),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 80),
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
            ),
          )
        ]),
      ),
    );
  }
}
