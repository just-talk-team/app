import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_talk/models/user_info.dart';

// ignore: must_be_immutable
class AvatarPage extends StatefulWidget {
  PageController pageController;
  UserInfoChange userI;
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
    if (widget.userI.photo != null) {
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
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
                  'Avatar',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 80),
            child: AutoSizeText(
              "Elige una imagen que te represente!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),

          //Content
          widget.userI.photo == null
              ? SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
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
                      widget.userI.photo,
                      height: 200.0,
                      width: 200.0,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Future getImage() async {
    var tempImage = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      widget.userI.photo = File(tempImage.path);
      validate();
    });
  }
}
