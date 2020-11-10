import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Badget extends StatefulWidget {
  Badget(
      {@required bool selected,
      @required IconData icon,
      @required String text,
      @required Function(bool) valueChanged})
      : assert(selected != null),
        assert(icon != null),
        assert(text != null),
        assert(valueChanged != null),
        _selected = selected,
        _icon = icon,
        _valueChanged = valueChanged,
        _text = text;

  final bool _selected;
  final IconData _icon;
  final String _text;
  final Function(bool) _valueChanged;

  @override
  _BadgetState createState() => _BadgetState();
}

class _BadgetState extends State<Badget> {
  bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget._selected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget._valueChanged(selected);
          selected = !selected;
        });
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    width: 2,
                    color: selected ? Color(0xffb3a407) : Color(0xff8a8a8a))),
            child: Icon(
              widget._icon,
              size: 40,
              color: selected ? Color(0xffb3a407) : Color(0xff8a8a8a),
            ),
          ),
          AutoSizeText(
            widget._text,
            maxLines: 2,
            style: TextStyle(
                color: selected ? Color(0xffb3a407) : Color(0xff8a8a8a)),
          )
        ],
      ),
    );
  }
}
