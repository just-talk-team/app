import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> SystemNavigator.pop(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Container(),
          title: Text("Home"),
        ),
      ),
    );
  }
}
