//INFO PAGE ======================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_talk/models/UserInput.dart';

class InfoPage extends StatefulWidget {
  PageController pageController;
  UserInput userI;
  InfoPage(this.userI, this.pageController);

  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  int _defaultChoiceIndex;
  List<String> _choices = <String>['femenino', 'masculino'];

  void validate() {
    debugPrint("PASSED TO");
    if (widget.userI.dateTime != null && widget.userI.genre != null) {
      widget.pageController.jumpToPage(1);
    }
  }

  Widget choiceChips() {
    return Expanded(
        child: ListView.builder(
            itemCount: _choices.length,
            itemBuilder: (BuildContext context, index) {
              return ChoiceChip(
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
                  });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Card(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 180),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Column(children: <Widget>[
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Mis Datos',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 15),
                    Text(
                      'Brindanos tus datos, para encontrar personas como tu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: MyTextFieldDatePicker(
                        labelText: "Date",
                        prefixIcon: Icon(Icons.date_range),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        lastDate: DateTime.now().add(Duration(days: 366)),
                        firstDate: DateTime(1970),
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        onDateChanged: (selectedDate) {
                          widget.userI.dateTime =
                              Timestamp.fromDate(selectedDate);
                          validate();
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                  ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 450),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Sexo',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    choiceChips(),
                  ],
                ),
              )
            ],
          ),
        ),
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
        border: OutlineInputBorder(),
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
