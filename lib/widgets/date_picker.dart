import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

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
      _dateFormat = DateFormat('dd-MM-yyyy');
    }

    _selectedDate = widget.initialDate;
    _controllerDate = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controllerDate.text = _dateFormat.format(_selectedDate);
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
      onTap: () async {
        var result = await showDate(context);
        if (result != null) {
          widget.onDateChanged(result);
          _selectedDate = result;
          setState(() {});
        }
      },
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<DateTime> showDate(BuildContext context) {
    DateTime _selectedDateAux = widget.initialDate;

    List<Widget> listButtonActions = [
      FlatButton(
        textColor: Color(0xffff3f82),
        child: Text(
          'ACEPTAR',
          style: TextStyle(
              letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pop(context, _selectedDateAux);
        },
      ),
      FlatButton(
        textColor: Color(0xffff3f82),
        child: Text(
          'CANCELAR',
          style: TextStyle(
              letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];

    var dialog = AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      content: Container(
        width: 300,
        child: DatePickerWidget(
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialDate: widget.initialDate,
          pickerTheme: DateTimePickerTheme(
            backgroundColor: Colors.white,
            itemTextStyle: TextStyle(color: Colors.black),
          ),
          onChange: ((DateTime date, list) {
            _selectedDateAux = date;
          }),
          looping: true,
        ),
      ),
      actions: listButtonActions,
    );

    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) => dialog);
  }
}
