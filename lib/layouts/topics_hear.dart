import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicsHear extends StatefulWidget {
  @override
  _TopicsHear createState() => _TopicsHear();
}

class _TopicsHear extends State<TopicsHear> {
  List<String> arrayTest = [
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US',
    'Clásicas de cachimbos',
    'Tips para examentes',
    'Mejor restaurante SM',
    'Fijas Calculo II',
    'Dragon Ball',
    'COVID',
    'Viajes',
    'Teorias de conspiracion',
    'Among US'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
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
                    '¿Sobre que puedo escuchar?',
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),

        //color: Colors.blueAccent,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: List<Widget>.generate(arrayTest.length, (int index) {
                  return Chip(
                    label: Text(arrayTest[index]),
                    onDeleted: () {
                      setState(() {
                        arrayTest.removeAt(index);
                      });
                    },
                  );
                }),
              ),
            )),
      ),
    );
  }
}
