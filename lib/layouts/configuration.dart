import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/widgets/date_picker.dart';

// ignore: must_be_immutable
class ConfigurationPage extends StatefulWidget {
  ConfigurationPage(this.userId, this.userInfo);
  final String userId;
  UserInfo userInfo;
  final List<String> multipleChoices = ['Masculino', 'Femenino'];

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  TextEditingController nickController;
  TextEditingController segmentController;

  FocusNode textFieldFocusNode;
  List<String> _multipleSelected;

  @override
  void initState() {
    super.initState();
    nickController = TextEditingController();
    segmentController = TextEditingController();
    textFieldFocusNode = FocusNode();
    _multipleSelected = [describeEnum(widget.userInfo.gender)];

    nickController.text = widget.userInfo.nickname;
  }

  @override
  void dispose() {
    super.dispose();
    nickController.dispose();
    segmentController.dispose();
    textFieldFocusNode.dispose();
  }

  Iterable<Widget> get companyWidgets sync* {
    for (String multipleChoice in widget.multipleChoices) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            label: Text(multipleChoice),
            selectedColor: Color(0xffb3a407),
            selected: _multipleSelected.contains(multipleChoice),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _multipleSelected.add(multipleChoice);
                } else {
                  _multipleSelected.removeWhere((String name) {
                    return name == multipleChoice;
                  });
                }
              });
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(widget.userInfo);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Configurar'),
          centerTitle: true,
          leading: IconButton(
            iconSize: 30,
            icon: Icon(Icons.keyboard_arrow_left),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              MyTextFieldDatePicker(
                  labelText: "Fecha de nacimiento",
                  suffixIcon: Icon(Icons.date_range),
                  lastDate: DateTime.now().add(Duration(days: 366)),
                  firstDate: DateTime(1970),
                  initialDate: widget.userInfo.birthdate,
                  onDateChanged: (selectedDate) {}),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText('Sexo',
                      textAlign: TextAlign.left,
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
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: segmentController,
                    decoration: InputDecoration(
                      labelText: 'Segmentos',
                      hintText: 'Correo de tu organización',
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
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
                        widget.userInfo.preferences.segments.add(email);
                      });
                    },
                  ),
                ],
              ),
              Container(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: List<Widget>.generate(
                          widget.userInfo.preferences.segments.length,
                          (int index) {
                        return Chip(
                          label:
                              Text(widget.userInfo.preferences.segments[index]),
                          onDeleted: () {
                            setState(() {
                              widget.userInfo.preferences.segments
                                  .removeAt(index);
                            });
                          },
                        );
                      }),
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  color: Color(0xFFb31020),
                  padding: EdgeInsets.all(18.0),
                  textColor: Colors.white,
                  onPressed: () async {},
                  icon: Icon(Icons.sentiment_satisfied, size: 18),
                  label: Text(
                    "Finalizar",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
