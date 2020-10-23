import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Preference extends StatefulWidget {
  //UserInput userI;
  //Preference(this.userI);
  @override
  _Preference createState() => _Preference();
}

class _Preference extends State<Preference> {
  int _defaultSegment;
  List<String> _choices = [
    'Sin segmentación',
    '@upc.edu.pe',
    '@cibertec.com.pe',
    '@gmail.com.pe'
  ];
  List<String> _multipleChoices = ['Masculino', 'Femenino'];
  List<String> _multipleSelected = [];
  static double _lowerValue = 20.0;
  static double _upperValue = 30.0;
  RangeValues _currentRangeValues = RangeValues(_lowerValue, _upperValue);
  String interval = "";

  void loadInfo() {
    //widget.userI.segments.forEach((element) {
    //  _choices.add(element.item2);
    //});
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
          title: Text('Preferencias'),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Content
            Column(
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
                        children:
                            List<Widget>.generate(_choices.length, (index) {
                          return FilterChip(
                            label: Text(_choices[index]),
                            shadowColor: Colors.yellowAccent,
                            selected: _defaultSegment == index,
                            selectedColor: Color(0xffb3a407),
                            onSelected: (bool selected) {
                              Text(
                                _choices[index],
                                style: TextStyle(color: Colors.white),
                              );
                              setState(() {
                                _defaultSegment = selected ? index : null;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Multiple choice chips
            Column(
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
            //Age
            Column(
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
            //Insignias
            Column(
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
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 2, color: Color(0xff8a8a8a))),
                          child: Icon(
                            Icons.hearing,
                            size: 40,
                            color: Color(0xff8a8a8a),
                          ),
                        ),
                        AutoSizeText(
                          'Buen oyente',
                          maxLines: 2,
                          style: TextStyle(color: Color(0xff8a8a8a)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 2, color: Color(0xff8a8a8a))),
                          child: Icon(
                            Icons.mood,
                            size: 40,
                            color: Color(0xff8a8a8a),
                          ),
                        ),
                        AutoSizeText(
                          'Buen conversador',
                          maxLines: 2,
                          style: TextStyle(color: Color(0xff8a8a8a)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 2, color: Color(0xff8a8a8a))),
                          child: Icon(
                            Icons.sentiment_very_satisfied,
                            size: 40,
                            color: Color(0xff8a8a8a),
                          ),
                        ),
                        AutoSizeText('Divertido',
                            maxLines: 2,
                            style: TextStyle(color: Color(0xff8a8a8a)))
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50),
              ],
            )
          ],
        )));
  }
}
