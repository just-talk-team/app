import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({String title, String message, Color color})
      : assert(message != null),
        assert(color != null),
        _title = title,
        _message = message,
        _color = color;

  final String _title;
  final String _message;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _title != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          _title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
                  child: Text(
                    _message,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'ACEPTAR',
                        style: TextStyle(
                            letterSpacing: 2,
                            color: _color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            letterSpacing: 2,
                            color: _color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ])),
    );
  }
}
