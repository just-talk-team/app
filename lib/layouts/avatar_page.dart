import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_talk/models/user_input.dart';

// ignore: must_be_immutable
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //Title
        Container(
          child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Avatar',
                style:
                    TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
        ),
        Column(
          children: [
            AutoSizeText(
              "No elijas una foto tuya!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              "Elige algo que te",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              "represente",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              "a ti",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ],
        ),

        //Content
        widget.userI.imgProfile == null
            ? SizedBox(
                height: 100,
                width: 100,
                child: FloatingActionButton(
                  backgroundColor: Color(0xFFB31048),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                ),
              )
            : GestureDetector(
                onTap: getImage,
                child: ClipOval(
                  child: Image.file(
                    widget.userI.imgProfile,
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              )
      ],
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
