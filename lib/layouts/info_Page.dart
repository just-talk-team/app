//INFO PAGE ======================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_talk/models/user_input.dart';

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
  List<String> _choices = <String>['Femenino', 'Masculino'];

  void validate() {
    debugPrint("PASSED TO");
    if (widget.userI.dateTime != null && widget.userI.genre != null) {
      widget.pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    }
  }

  Widget choiceChips() {
    return Container(
        height: 44.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _choices.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0,0,10,0),
                child: ChoiceChip(
                    label: Text(_choices[index]),
                    selected: _defaultChoiceIndex == index,
                    selectedColor: Colors.green,
                    onSelected: (bool selected) {
                      setState(() {
                        _defaultChoiceIndex = selected ? index : null;
                        ///////////////////////////////////////////////
                        if (_defaultChoiceIndex == 0) {
                          widget.userI.genre = "woman";
                        } else {
                          widget.userI.genre = "man";
                        }
                        validate();
                        ///////////////////////////////////////////////
                      });
                    }),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 110, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Mis Datos',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding:
                const EdgeInsets.symmetric(
                  vertical: 80.0, 
                  horizontal: 30.0),
            child: Text(
              'Brindanos tus datos, para encontrar personas como tu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: MyTextFieldDatePicker(
              labelText: "Date",
              prefixIcon: Icon(Icons.date_range),
              suffixIcon: Icon(Icons.arrow_drop_down),
              lastDate: DateTime.now().add(Duration(days: 366)),
              firstDate: DateTime(1970),
              initialDate: DateTime.now().add(Duration(days: 1)),
              onDateChanged: (selectedDate) {
                widget.userI.dateTime = Timestamp.fromDate(selectedDate);
                validate();
              },
            ),
          ),
          SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sexo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          choiceChips(),
        ],
      ),
    );
  }
}

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;

  MyTextFieldDatePicker({
    Key key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate.isBefore(firstDate),
            'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
            'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
            'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  TextEditingController _controllerDate;
  DateFormat _dateFormat;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat.MMMEd();
    }

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}
