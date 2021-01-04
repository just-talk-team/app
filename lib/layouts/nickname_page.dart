import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';

// ignore: must_be_immutable
class NicknamePage extends StatefulWidget {
  PageController pageController;
  UserInfoChange userI;
  NicknamePage(this.userI, this.pageController);
  @override
  _NicknamePage createState() => _NicknamePage();
}

class _NicknamePage extends State<NicknamePage> {
  TextEditingController nickController;
  FocusNode textFieldFocusNode;

  void validate() {
    debugPrint("PASSED TO");
    debugPrint(widget.userI.toString());
    if (widget.userI.nickname != null) {
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
  }

  @override
  void initState() {
    super.initState();

    nickController = TextEditingController();
    textFieldFocusNode = FocusNode();

    if (widget.userI.nickname != null)
      nickController.text = widget.userI.nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          //Title
          Container(
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Nickname',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 80),
              child: AutoSizeText(
                "¿Con que nombre quieres que te conozcan?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              )),
          //Content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  TextFormField(
                    key: Key("Nickname input"),
                    controller: nickController,
                    focusNode: textFieldFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Nickname',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.grey, width: 0.0),
                      ),
                    ),
                  ),
                  IconButton(
                    key: Key("Accept nickname"),
                    icon: Icon(Icons.send),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        if (nickController.text.isEmpty) {
                          return;
                        }
                        widget.userI.nickname = nickController.text;
                        validate();
                      });
                    },
                  )
                ]),
          ),
          SizedBox(height: 100)
        ],
      ),
    );
  }
}
