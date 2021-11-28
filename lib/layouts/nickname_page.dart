import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';

// ignore: must_be_immutable
class NicknamePage extends StatefulWidget {
  PageController pageController;
  UserInfoChange userI;
  UserService userService;

  NicknamePage(this.userI, this.pageController, this.userService);
  @override
  _NicknamePage createState() => _NicknamePage();
}

class _NicknamePage extends State<NicknamePage> {
  TextEditingController nickController;
  FocusNode textFieldFocusNode;

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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Title
          Container(
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Nickname',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
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
            child: TextFormField(
              key: Key("Nickname input"),
              controller: nickController,
              decoration: InputDecoration(
                hintText: 'Nickname',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                suffixIcon: IconButton(
                  key: Key("Accept nickname"),
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (nickController.text.isNotEmpty &&
                        !await widget.userService
                            .validateNickname(nickController.text)) {
                      return;
                    }
                    widget.userI.nickname = nickController.text;
                    widget.pageController.nextPage(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
