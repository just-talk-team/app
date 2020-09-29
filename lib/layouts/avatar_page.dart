import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_talk/models/UserInput.dart';

class AvatarPage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
  AvatarPage(this.userI, this.pageController);
  @override
  _AvatarPage createState() => _AvatarPage();
}

class _AvatarPage extends State<AvatarPage> {
  final formkey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  String url;

  void validate() {
    debugPrint("PASSED TO");
    if (widget.userI.imgProfile != null) {
      widget.pageController.jumpToPage(3);
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
                Positioned(
                    top: 500.0,
                    child: GestureDetector(
                      onTap: getImage,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 180),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Column(children: <Widget>[
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Avatar',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(height: 45),
                      Text(
                        'No elijas una foto tuya! elige algo que te represente a ti :)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 45),
                      Center(
                        child: widget.userI.imgProfile == null
                            ? FloatingActionButton(
                                onPressed: getImage,
                                tooltip: 'Pick Image',
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFb31020)),
                                ),
                              )
                            : Image.file(
                                widget.userI.imgProfile,
                                height: 150.0,
                                width: 150.0,
                              ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future getImage() async {
    var tempImage = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      widget.userI.imgProfile = File(tempImage.path);
      validate();
    });
  }
}
