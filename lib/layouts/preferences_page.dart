import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

// ignore: must_be_immutable
class Preference extends StatefulWidget {
  //UserInput userI;
  //Preference(this.userI);
  @override
  _Preference createState() => _Preference();
}

class _Preference extends State<Preference> {
  auth.User _currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  AuthenticationService authService;
  RangeValues _currentRangeValues = RangeValues(_lowerValue, _upperValue);

  //Ages
  static double _lowerValue = 20;
  static double _upperValue = 30;
  //Insignias
  List<int> insignias = [0, 0, 0];
  //Genders
  List<String> _multipleChoices = ['Masculino', 'Femenino'];
  List<String> _multipleSelected = [];
  //Segments Multiple
  List<String> _loadedRegisteredSegments = [];
  List<String> _loadedSelectedSegments = [];
  List<String> _segmentsSelected = [];
  //Segments

  String interval = "";

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    var uid = BlocProvider.of<AuthenticationCubit>(context).state.user.id;

    DocumentReference checkUser =
        FirebaseFirestore.instance.collection('users').doc(uid);
    checkUser.get().then((data) => {
          if (data.exists) {loadData()}
        });
  }

  loadData() async {
    callState();
  }

  callState() {
    setState(() {});
  }

  insertData() async {}

  Iterable<Widget> get segmentsMultipleChip sync* {
    for (String segment in _loadedSelectedSegments) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            label: Text(segment),
            selectedColor: Color(0xffb3a407),
            selected: _segmentsSelected.contains(segment),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _segmentsSelected.add(segment);
                } else {
                  _segmentsSelected.removeWhere((String name) {
                    return name == segment;
                  });
                }
              });
            }),
      );
    }
  }

  Iterable<Widget> get companyWidgets sync* {
    for (String multipleChoice in _multipleChoices) {
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
    return Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    insertData();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Container(
                    child: Icon(Icons.keyboard_arrow_left,
                        size: 40, color: Color(0xff666666)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Preferencias',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        body:
            //Content
            Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Single choice chip
                Container(
                  //color: Colors.amberAccent,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 30),
                          AutoSizeText('Segmentos',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: segmentsMultipleChip.toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Multiple choice chips
                Container(
                  //color: Colors.blueAccent,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 30),
                          AutoSizeText('Sexo',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              children: companyWidgets.toList(),
                            )),
                      ),
                    ],
                  ),
                ),
                //Age
                Container(
                  //color: Colors.lightGreen,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 30),
                          AutoSizeText('Edad',
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              width: 280,
                              child: Material(
                                  child: RangeSlider(
                                activeColor: Color(0xffb3a407),
                                inactiveColor: Color(0xffb3a407),
                                values: _currentRangeValues,
                                min: 18,
                                max: 99,
                                divisions: 100,
                                labels: RangeLabels(
                                  _currentRangeValues.start.round().toString(),
                                  _currentRangeValues.end.round().toString(),
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _currentRangeValues = values;
                                    interval = values.start.toInt().toString() +
                                        " - " +
                                        values.end.toInt().toString();
                                  });
                                },
                              ))),
                          Container(
                            child: Center(
                              child: AutoSizeText(
                                interval,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff666666)),
                              ),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                //Insignias
                Container(
                  //color: Colors.cyanAccent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 30),
                          AutoSizeText('Insignias',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                insignias[0] == 0
                                    ? insignias[0] = 1
                                    : insignias[0] = 0;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 2,
                                          color: insignias[0] == 1
                                              ? Color(0xffb3a407)
                                              : Color(0xff8a8a8a))),
                                  child: Icon(
                                    Icons.hearing,
                                    size: 40,
                                    color: insignias[0] == 1
                                        ? Color(0xffb3a407)
                                        : Color(0xff8a8a8a),
                                  ),
                                ),
                                AutoSizeText(
                                  'Buen oyente',
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: insignias[0] == 1
                                          ? Color(0xffb3a407)
                                          : Color(0xff8a8a8a)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                insignias[1] == 0
                                    ? insignias[1] = 1
                                    : insignias[1] = 0;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 2,
                                          color: insignias[1] == 1
                                              ? Color(0xffb3a407)
                                              : Color(0xff8a8a8a))),
                                  child: Icon(
                                    Icons.mood,
                                    size: 40,
                                    color: insignias[1] == 1
                                        ? Color(0xffb3a407)
                                        : Color(0xff8a8a8a),
                                  ),
                                ),
                                AutoSizeText(
                                  'Buen conversador',
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: insignias[1] == 1
                                          ? Color(0xffb3a407)
                                          : Color(0xff8a8a8a)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                insignias[2] == 0
                                    ? insignias[2] = 1
                                    : insignias[2] = 0;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 2,
                                          color: insignias[2] == 1
                                              ? Color(0xffb3a407)
                                              : Color(0xff8a8a8a))),
                                  child: Icon(
                                    Icons.sentiment_very_satisfied,
                                    size: 40,
                                    color: insignias[2] == 1
                                        ? Color(0xffb3a407)
                                        : Color(0xff8a8a8a),
                                  ),
                                ),
                                AutoSizeText('Divertido',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: insignias[2] == 1
                                            ? Color(0xffb3a407)
                                            : Color(0xff8a8a8a)))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
