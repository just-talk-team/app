import 'package:flutter/material.dart';
import 'package:just_talk/widgets/badget.dart';

class Results extends StatelessWidget {
  const Results({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height / 3,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.add_alarm,
                    size: 40,
                    color: Color(0xffff3f82),
                  ),
                  Text(
                    '5 min',
                    style: TextStyle(color: Color(0xffff3f82)),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Badget(
                            selected: false,
                            icon: Icons.hearing,
                            text: 'Buen oyente',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.mood,
                            text: 'Buen conversador',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.sentiment_very_satisfied_rounded,
                            text: 'Divertido',
                            valueChanged: null),
                      ],
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'FINALIZAR',
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Color(0xffff3f82),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Results2 extends StatelessWidget {
  const Results2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height / 3,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.add_alarm,
                    size: 40,
                    color: Color(0xffff3f82),
                  ),
                  Text(
                    '5 min',
                    style: TextStyle(color: Color(0xffff3f82)),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Badget(
                            selected: false,
                            icon: Icons.hearing,
                            text: 'Buen oyente',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.mood,
                            text: 'Buen conversador',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.sentiment_very_satisfied_rounded,
                            text: 'Divertido',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.arrow_forward,
                            text: 'Omitir',
                            valueChanged: null),
                      ],
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Results3 extends StatelessWidget {
  const Results3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height / 3,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.add_alarm,
                    size: 40,
                    color: Color(0xffff3f82),
                  ),
                  Text(
                    '5 min',
                    style: TextStyle(color: Color(0xffff3f82)),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Badget(
                            selected: false,
                            icon: Icons.hearing,
                            text: 'Buen oyente',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.mood,
                            text: 'Buen conversador',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.sentiment_very_satisfied_rounded,
                            text: 'Divertido',
                            valueChanged: null),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Badget(
                            selected: false,
                            icon: Icons.star_border,
                            text: 'El Mejor',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.mood,
                            text: 'Interesante',
                            valueChanged: null),
                        Badget(
                            selected: false,
                            icon: Icons.support_outlined,
                            text: 'Ayudante',
                            valueChanged: null),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'FINALIZAR',
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Color(0xffff3f82),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
