import 'dart:io';

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
      widget.pageController.jumpToPage(3);
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
              'Avatar',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Text(
            'No elijas una foto tuya! elige algo que te represente a ti :)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
      ]),
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
