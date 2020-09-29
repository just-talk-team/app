import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListenTopics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("¿Sobre qué puedo escuchar?"),
<<<<<<< Updated upstream
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.arrow_back),)
          
        ],
      ),
=======
       centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            hoverColor: Color.fromRGBO(179, 16, 72, 1),
            disabledColor: Colors.black,
            onPressed: null),
        actions: [],
      ),
      body: null,
>>>>>>> Stashed changes
    );
  }
}
