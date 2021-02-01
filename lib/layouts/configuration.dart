import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:just_talk/widgets/confirm_dialog.dart';

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

  List<Gender> multipleChoices;
  UserService userService;
  bool segmentFlag;

  @override
  void initState() {
    super.initState();

    userSegments = [];
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool flag = false;

        if (nickController.text != widget.userInfo.nickname) {
          flag = true;
          await userService.updateUserConfiguration(
              widget.userId, nickController.text);
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

              if (nickController.text != widget.userInfo.nickname) {
                flag = true;
                await userService.updateUserConfiguration(
                    widget.userId, nickController.text);
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
                      child: TextFormField(
                        controller: segmentController,
                        decoration: InputDecoration(
                          hintText: 'Correo de tu organización',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          suffixIcon: IconButton(
                            key: Key("Add segment"),
                            icon: Icon(Icons.send),
                            onPressed: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              String email = segmentController.text;
                              segmentController.clear();

                              if (!EmailValidator.validate(email) &&
                                  userSegments.contains(email)) {
                                return;
                              }

                              setState(() {
                                userSegments.add(email);
                                segmentFlag = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  margin: const EdgeInsets.symmetric(vertical: 10),
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
                          deleteIconColor: Theme.of(context).primaryColor,
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
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    key: Key('Finalizar'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    textColor: Colors.white,
                    onPressed: () async {
                      bool result = await showDialog(
                          builder: (BuildContext context) {
                            return ConfirmDialog(
                                color: Theme.of(context).accentColor,
                                title: "Confirmar accion",
                                message: "Desea eliminar su cuenta");
                          },
                          context: context);

                      if (result) {
                        await userService.deleteUser(widget.userId);
                        BlocProvider.of<AuthenticationCubit>(context).logOut();
                      }
                    },
                    child: Text(
                      "Eliminar cuenta",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
