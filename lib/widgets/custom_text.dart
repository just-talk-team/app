import 'package:flutter/material.dart';
import 'package:just_talk/utils/enums.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  String text;
  MessageType type;

  //Loaded by sharedPreferences
  CustomText(this.text, this.type);
  double maxW;

  @override
  Widget build(BuildContext context) {
    maxW = ((MediaQuery.of(context).size.width) * 0.75).roundToDouble();

    MainAxisAlignment mainAxis;
    Color color;
    BoxDecoration boxDecoration;

    switch (this.type) {
      case MessageType.CurrentUser:
        mainAxis = MainAxisAlignment.end;
        color = Color(0xff959595);
        boxDecoration = BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: color));
        break;

      case MessageType.Friend:
        mainAxis = MainAxisAlignment.start;
        color = Color(0xffb3a407);
        boxDecoration = BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: color));
        break;

      case MessageType.Information:
        mainAxis = MainAxisAlignment.center;
        color = Colors.black.withOpacity(0.5);
        boxDecoration = null;
    }

    return Row(
      mainAxisAlignment: mainAxis,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: maxW),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.symmetric(vertical: 3),
            decoration: boxDecoration,
            child: Text(
              text,
              style: TextStyle(color: color),
            )),
      ],
    );
  }
}