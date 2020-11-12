import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/models/user_profile.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  List<String> arrayTest = [
    'upc.edu.pe',
    'cibertec.edu.pe',
    'googe.com.pe',
    'upc.edu.pe',
    'cibertec.edu.pe',
    'googe.com.pe',
    'upc.edu.pe',
    'cibertec.edu.pe',
    'googe.com.pe',
    'upc.edu.pe',
    'cibertec.edu.pe',
    'googe.com.pe',
    'upc.edu.pe',
    'cibertec.edu.pe',
    'googe.com.pe',
  ];
  List<String> topicsHear = [
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
  Future<UserProfile> getUserInfo(BuildContext context) async {
    UserService userService = UserService();
    User user = BlocProvider.of<AuthenticationCubit>(context).state.user;
    return await userService.getUserInfoProfile(user.id);
  }

 
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
                    'Perfil',
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                'https://writestylesonline.com/wp-content/uploads/2018/11/Three-Statistics-That-Will-Make-You-Rethink-Your-Professional-Profile-Picture.jpg',
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Alexa',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Text(
                            'Mujer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '18 años',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                //Segments
                Container(
                  height: 80,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List<Widget>.generate(arrayTest.length,
                            (int index) {
                          return Chip(
                            label: Text(arrayTest[index]),
                          );
                        }),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //Insignias
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
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
                                    width: 2, color: Color(0xffb3a407))),
                            child: Icon(
                              Icons.hearing,
                              size: 30,
                              color: Color(0xffb3a407),
                            ),
                          ),
                          AutoSizeText(
                            'Buen oyente',
                            maxLines: 2,
                            style: TextStyle(color: Color(0xffb3a407)),
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
                                    width: 2, color: Color(0xffb3a407))),
                            child: Icon(
                              Icons.mood,
                              size: 30,
                              color: Color(0xffb3a407),
                            ),
                          ),
                          AutoSizeText(
                            'Buen conversador',
                            maxLines: 2,
                            style: TextStyle(color: Color(0xffb3a407)),
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
                                    width: 2, color: Color(0xffb3a407))),
                            child: Icon(
                              Icons.sentiment_very_satisfied,
                              size: 30,
                              color: Color(0xffb3a407),
                            ),
                          ),
                          AutoSizeText(
                            'Divertido',
                              maxLines: 2,
                              style: TextStyle(color: Color(0xffb3a407)))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
            //TopicsHear
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children:
                        List<Widget>.generate(topicsHear.length, (int index) {
                      return Chip(
                        label: Text(topicsHear[index]),
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
