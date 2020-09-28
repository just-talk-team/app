import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_talk/utils/custom_icons_icons.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Just Talk'),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.build),
            )
        ],

      ),
     
      body:Column(
          //alignment: WrapAlignment.center,
          children: [
            Center(
              child: Container(
                  padding: EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 0.0),
                  alignment: Alignment.center,
                  child: AppTitle()
              ),
            ),
            
            Center(child: RaisedButton(
                color: Color.fromRGBO(179, 16, 72, 1),
                child: Text('Just Talk'),
                textColor: Colors.white,
                onPressed: () => build(context),
            )
            )
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Just Talk'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Amigos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Mi Perfil'),
          ),
        ],
      
        selectedItemColor: Colors.black,
     
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          child: Text(
            '¡Conversa al instante con personas que quieren  escucharte! :)',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'ArialRounded',
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}