//INFO PAGE ======================================================================
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:just_talk/widgets/date_picker.dart';

// ignore: must_be_immutable
class InfoPage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
  InfoPage(this.userI, this.pageController);

  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  int _defaultChoiceIndex;

  List<Gender> _choices = [Gender.Femenino, Gender.Masculino];

  void validate() {
    debugPrint("PASSED TO");
    if (widget.userI.dateTime != null && widget.userI.genre != null) {
      widget.pageController
          .nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
  }

  @override
  void initState() {
    super.initState();
    _defaultChoiceIndex = null;

    if (widget.userI.genre == null) return;
    _defaultChoiceIndex = widget.userI.genre.index;

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
                    label: Text(describeEnum(_choices[index])),
                    selected: (index == _defaultChoiceIndex),
                    selectedColor: Colors.green,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.userI.genre = _choices[index];
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
                    'Mis Datos',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: AutoSizeText(
                'Brindanos tus datos, para encontrar personas como tu!',
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
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Center(
                    child: MyTextFieldDatePicker(
                      key: Key('DatePicker'),
                      labelText: "Date",
                      prefixIcon: Icon(Icons.date_range),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                      firstDate: DateTime(1970),
                      initialDate: widget.userI.dateTime.toDate(),
                      onDateChanged: (selectedDate) {
                        widget.userI.dateTime =
                            Timestamp.fromDate(selectedDate);
                        validate();
                      },
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sexo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: Center(child: choiceChips())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
