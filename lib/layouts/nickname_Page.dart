import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/UserInput.dart';

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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Card(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 180),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Column(children: <Widget>[
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Nickname',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 45),
                    Text(
                      'Elige un nombre de pila! :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    TextFormField(
                      controller: nickController,
                      decoration: InputDecoration(
                          hintText: 'Correo de tu organización',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.userI.nickname = nickController.text;
                                validate();
                              });
                            },
                            icon: Icon(Icons.send),
                          )),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
