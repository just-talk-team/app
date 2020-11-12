import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_input.dart';

// ignore: must_be_immutable
class NicknamePage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
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
      child: Stack(
        children: <Widget>[
          //Title
          Container(
              child: Column(
            children: <Widget>[
              SizedBox(height: 110),
              Container(
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Nickname',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(height: 50),
              Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      children: [
                        AutoSizeText(
                          "Elige un nombre de pila!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          "¿Con qué nombre quieres",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          "que te conozcan?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    )),
              ),
            ],
          )),
          //Content
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
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
                  SizedBox(height: 50)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
