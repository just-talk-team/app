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

  void validate() {
    debugPrint("PASSED TO");
    if (widget.userI.nickname != null) {
      widget.pageController.jumpToPage(2);
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
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/5),
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
          child: TextFormField(
            controller: nickController,
            decoration: InputDecoration(
                hintText: 'Nickname',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.userI.nickname = nickController.text;
                      validate();
                    });
                  },
                  icon: Icon(Icons.send),
                )),
          ),
        )
      ]),
    );
  }
}
