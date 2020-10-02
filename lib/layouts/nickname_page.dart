import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_input.dart';

class NicknamePage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
  NicknamePage(this.userI, this.pageController);
  @override
  _NicknamePage createState() => _NicknamePage();
}

class _NicknamePage extends State<NicknamePage> {
  TextEditingController nickController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  void validate() {
    debugPrint("PASSED TO");
    debugPrint(widget.userI.toString());
    if (widget.userI.nickname != null) {
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
      child: Column(children: <Widget>[
        FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Nickname',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width / 5),
          child: Text(
            'Elige un nombre de pila! :)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(alignment: Alignment.centerRight, children: <Widget>[
            TextFormField(
              controller: nickController,
              focusNode: textFieldFocusNode,
              decoration: InputDecoration(
                hintText: 'Nickname',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  widget.userI.nickname = nickController.text;
                  validate();
                });
              },
            )
          ]),
        )
      ]),
    );
  }
}
