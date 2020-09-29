import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TalkTopics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("¿De qué puedo hablar?"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            hoverColor: Color.fromRGBO(179, 16, 72, 1),
            disabledColor: Colors.black,
            onPressed: null),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            hoverColor: Color.fromRGBO(179, 16, 72, 1),
            disabledColor: Colors.black,
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: [
          ListBody(),
          TextField(decoration: InputDecoration(
    hintText: 'Puedo hablar de...'
  ),
  ),
        ],
      ),
    );
  }
}
