import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_talk/models/user_input.dart';

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
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
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
                      'Avatar',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(height: 70),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: AutoSizeText(
                  'No elijas una foto tuya! elige algo que te represente a ti :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
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
                      Center(
                        child: widget.userI.imgProfile == null
                            ? SizedBox(
                                height: 100,
                                width: 100,
                                child: FloatingActionButton(
                                  backgroundColor: Color(0xFFb31020),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  onPressed: getImage,
                                  tooltip: 'Pick Image',
                                ),
                              )
                            : Image.file(
                                widget.userI.imgProfile,
                                height: 150.0,
                                width: 150.0,
                              ),
                      ),
                    ])),
          )
        ],
      ),
    );
  }

  Future getImage() async {
    var tempImage = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      widget.userI.imgProfile = File(tempImage.path);
      validate();
    });
  }
}