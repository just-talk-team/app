import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  Badge(
      {@required bool selected,
      @required IconData icon,
      @required String text,
      @required Function(bool) valueChanged,
      double iconSize = 30,
      double textSize = 14,
      Color selectedColor = const Color(0xffb3a407),
      bool active = true})
      : assert(selected != null),
        assert(icon != null),
        assert(text != null),
        assert(valueChanged != null),
        _selected = selected,
        _icon = icon,
        _valueChanged = valueChanged,
        _text = text,
        _iconSize = iconSize,
        _textSize = textSize,
        _selectedColor = selectedColor,
        _active = active;

  final bool _selected;
  final IconData _icon;
  final String _text;
  final Function(bool) _valueChanged;
  final double _iconSize;
  final double _textSize;
  final Color _selectedColor;
  final bool _active;

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
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
        if (widget._active) {
          setState(() {
            widget._valueChanged(selected);
            selected = !selected;
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    width: 2,
                    color: selected
                        ? widget._selectedColor
                        : Colors.black.withOpacity(0.5))),
            child: Icon(
              widget._icon,
              size: widget._iconSize,
              color: selected
                  ? widget._selectedColor
                  : Colors.black.withOpacity(0.5),
            ),
          ),
          AutoSizeText(
            widget._text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: selected
                    ? widget._selectedColor
                    : Colors.black.withOpacity(0.5),
                fontSize: widget._textSize),
          ),
        ],
      ),
    );
  }
}
