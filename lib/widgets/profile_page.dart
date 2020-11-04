import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';

import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this._index, this._navbarCubit);

  final int _index;
  final NavbarCubit _navbarCubit;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserInfo userInfo;

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

  Future<UserInfo> getUser(BuildContext context) async {
    UserService userService = UserService();
    User user = BlocProvider.of<AuthenticationCubit>(context).state.user;
    return await userService.getUser(user.id, user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi perfil',
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                if (userInfo != null) {
                  Navigator.pushNamed(context, '/configuration', arguments: {
                    'userId': BlocProvider.of<AuthenticationCubit>(context)
                        .state
                        .user
                        .id,
                    'userInfo': userInfo
                  }).then((value) {
                    setState(() {});
                  });
                }
              }),
        ],
      ),
      body: FutureBuilder(
          future: getUser(context),
          builder: (context, AsyncSnapshot<UserInfo> user) {
            userInfo = user.data;

            if (user.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                user.data.photo,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                child: Text(
                                  user.data.nickname,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              Text(describeEnum(user.data.gender),
                                  style: Theme.of(context).textTheme.caption),
                              Text("${user.data.age} años",
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xffb3a407))),
                                    child: Icon(
                                      Icons.sentiment_very_satisfied,
                                      size: 30,
                                      color: Color(0xffb3a407),
                                    ),
                                  ),
                                  AutoSizeText('Divertido',
                                      maxLines: 2,
                                      style:
                                          TextStyle(color: Color(0xffb3a407)))
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
                              children: List<Widget>.generate(topicsHear.length,
                                  (int index) {
                                return Chip(
                                  label: Text(topicsHear[index]),
                                );
                              }),
                            ),
                          )),
                    )
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_satisfied),
            title: Text('Just Talk'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Amigos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mi perfil'),
          ),
        ],
        currentIndex: widget._index,
        onTap: (index) {
          switch (index) {
            case 0:
              widget._navbarCubit.toHome();
              break;
            case 1:
              widget._navbarCubit.toContacts();
              break;
            case 2:
              widget._navbarCubit.toProfile();
              break;
          }
        },
      ),
    );
  }
}
