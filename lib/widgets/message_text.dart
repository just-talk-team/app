import 'package:flutter/material.dart';
import 'package:just_talk/utils/enums.dart';

class MessageText extends StatelessWidget {
  final String _text;
  final MessageType _type;
  final Color _color;
  final MainAxisAlignment _alignment;

  MessageText(
      {String text, MessageType type, Color color, MainAxisAlignment alignment})
      : assert(text != null),
        assert(type != null),
        assert(type == MessageType.Information || color != null),
        assert(type == MessageType.Information || alignment != null),
        _text = text,
        _type = type,
        _color = color,
        _alignment = alignment;

  @override
  Widget build(BuildContext context) {
    double maxW = ((MediaQuery.of(context).size.width) * 0.75).roundToDouble();

    MainAxisAlignment mainAxis;
    Color textColor;
    BoxDecoration boxDecoration;

    switch (_type) {
      case MessageType.Message:
        mainAxis = _alignment;
        textColor = Colors.white;
        boxDecoration = BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: _color);
        break;

      case MessageType.Information:
        mainAxis = MainAxisAlignment.center;
        textColor = Colors.black.withOpacity(0.5);
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
              _text,
              style: TextStyle(color: textColor),
            )),
      ],
    );
  }
}
