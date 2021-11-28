//INFO PAGE ======================================================================
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:just_talk/widgets/date_picker.dart';

// ignore: must_be_immutable
class InfoPage extends StatefulWidget {
  PageController pageController;
  UserInfoChange userI;

  InfoPage(this.userI, this.pageController);

  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  int _defaultChoiceIndex;

  List<Gender> _choices = [Gender.Femenino, Gender.Masculino];

  bool validateAge() {
    if (widget.userI.age < MIN_AGE) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        flushbarPosition: FlushbarPosition.BOTTOM,
        messageText: Text(
          'La edad minima son 15 años',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      ).show(context);
      return false;
    }
    return true;
  }

  void validate() {
    if (validateAge() && widget.userI.gender != null) {
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
  }

  @override
  void initState() {
    super.initState();
    _defaultChoiceIndex = null;
    if (widget.userI.gender == null) return;
    _defaultChoiceIndex = widget.userI.gender.index;
  }

  Widget choiceChips() {
    return Container(
        height: 44.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _choices.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: ChoiceChip(
                    padding: EdgeInsets.all(10),
                    label: Text(
                      describeEnum(_choices[index]),
                      style: (index == _defaultChoiceIndex)
                          ? TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.normal,
                              color: Colors.white)
                          : TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.normal),
                    ),
                    selected: (index == _defaultChoiceIndex),
                    selectedColor: Theme.of(context).accentColor,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.userI.gender = _choices[index];
                        _defaultChoiceIndex = index;
                        validate();
                        ///////////////////////////////////////////////
                      });
                    }),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Title
          Container(
            child: Text(
              'Mis Datos',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: AutoSizeText(
              "Mantén conversaciones interesantes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),

          //Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                MyTextFieldDatePicker(
                  key: Key('DatePicker'),
                  labelText: "Fecha de Nacimiento",
                  prefixIcon: Icon(
                    Icons.date_range,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  lastDate: DateTime.now().add(Duration(days: 366)),
                  firstDate: DateTime(1970),
                  initialDate: widget.userI.birthdate,
                  onDateChanged: (selectedDate) {
                    widget.userI.birthdate = selectedDate;
                    validate();
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sexo',
                    style: TextStyle(
                        fontSize: 20, color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(child: choiceChips()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
