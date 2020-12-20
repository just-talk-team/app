import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:just_talk/widgets/date_picker.dart';

class ConfigurationPage extends StatefulWidget {
  ConfigurationPage({this.userId, this.userInfo, this.userService});

  final String userId;
  final UserInfo userInfo;
  final UserService userService;

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  List<String> userSegments;

  TextEditingController nickController;
  TextEditingController segmentController;
  FocusNode textFieldFocusNode;

  DateTime userBirthdate;
  Gender userGender;

  List<Gender> multipleChoices;
  UserService userService;
  bool segmentFlag;

  @override
  void initState() {
    super.initState();

    userGender = widget.userInfo.gender;
    userSegments = [];
    userBirthdate = widget.userInfo.birthdate;

    segmentFlag = false;

    nickController = TextEditingController();
    segmentController = TextEditingController();
    textFieldFocusNode = FocusNode();
    multipleChoices = Gender.values;

    nickController.text = widget.userInfo.nickname;

    userService = RepositoryProvider.of<UserService>(context);

    userService.getSegments(widget.userId).then((value) {
      userSegments = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    nickController.dispose();
    segmentController.dispose();
    textFieldFocusNode.dispose();
  }

  Iterable<Widget> get companyWidgets sync* {
    for (Gender gender in multipleChoices) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            showCheckmark: false,
            label: Text(
              describeEnum(gender),
              style: (userGender == gender)
                  ? TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      color: Colors.white)
                  : TextStyle(
                      fontFamily: "Roboto", fontWeight: FontWeight.bold),
            ),
            selectedColor: Color(0xffb3a407),
            selected: userGender == gender,
            onSelected: (bool selected) {
              userGender = gender;
              setState(() {});
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool flag = false;

        if (nickController.text != widget.userInfo.nickname ||
            userGender != widget.userInfo.gender ||
            userBirthdate != widget.userInfo.birthdate) {
          flag = true;
          await userService.updateUserConfiguration(
              widget.userId, nickController.text, userGender, userBirthdate);
        }
        if (segmentFlag) {
          flag = true;
          await userService.updateSegments(widget.userId, userSegments);
        }

        Navigator.of(context).pop(flag);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Configurar'),
          centerTitle: true,
          leading: IconButton(
            iconSize: 30,
            icon: Icon(Icons.keyboard_arrow_left),
            color: Colors.black,
            onPressed: () async {
              bool flag = false;

              if (nickController.text != widget.userInfo.nickname ||
                  userGender != widget.userInfo.gender ||
                  userBirthdate != widget.userInfo.birthdate) {
                flag = true;
                await userService.updateUserConfiguration(widget.userId,
                    nickController.text, userGender, userBirthdate);
              }
              if (segmentFlag) {
                flag = true;
                await userService.updateSegments(widget.userId, userSegments);
              }

              Navigator.of(context).pop(flag);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: nickController,
                  focusNode: textFieldFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: MyTextFieldDatePicker(
                    labelText: "Fecha de nacimiento",
                    suffixIcon: Icon(Icons.date_range),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                    firstDate: DateTime(1970),
                    initialDate: userBirthdate,
                    onDateChanged: (selectedDate) {
                      userBirthdate = selectedDate;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText('Sexo',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: companyWidgets.toList(),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText('Segmentos',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: segmentController,
                            decoration: InputDecoration(
                              hintText: 'Correo de tu organización',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                            ),
                          ),
                          IconButton(
                            key: Key("Add segment"),
                            icon: Icon(Icons.send),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String email = segmentController.text;
                              if (!EmailValidator.validate(email)) {
                                return;
                              }
                              setState(() {
                                userSegments.add(email);
                                segmentFlag = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(userSegments.length,
                            (int index) {
                          return Chip(
                            label: Text(userSegments[index]),
                            shape: StadiumBorder(
                                side: BorderSide(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.5))),
                            deleteIconColor: Color(0xFFB31048),
                            backgroundColor: Colors.transparent,
                            onDeleted: () {
                              setState(() {
                                userSegments.removeAt(index);
                                segmentFlag = true;
                              });
                            },
                          );
                        }),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
