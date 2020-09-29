import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListenTopics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("¿Sobre qué puedo escuchar?"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.arrow_back),)
          
        ],
      ),
    );
  }
}
