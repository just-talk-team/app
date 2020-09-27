import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/widgets/home_page.dart';

class Home extends StatefulWidget {
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
  ];

  static List<String> _titles = <String>['Just Talk'];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Home._titles.elementAt(_selectedIndex),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.build),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => BlocProvider.of<AuthenticationCubit>(context).logOut(),
            ),
          ],
        ),
        body: Home._widgetOptions.elementAt(_selectedIndex),
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
