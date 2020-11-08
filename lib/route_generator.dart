import 'package:flutter/material.dart';
import 'package:just_talk/layouts/configuration.dart';
import 'package:just_talk/layouts/home.dart';
import 'package:just_talk/layouts/login.dart';
import 'package:just_talk/layouts/preferences_page.dart';
import 'package:just_talk/layouts/register.dart';
import 'package:just_talk/layouts/splash.dart';
import 'package:just_talk/layouts/topics_hear.dart';
import 'package:just_talk/layouts/topics_talk.dart';


class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map arg = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Splash());
      case '/home':
        return MaterialPageRoute(builder: (context) => Home());
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
      case '/register':
        return MaterialPageRoute(builder: (context) => Register());
      case '/preference':
        return MaterialPageRoute(builder: (context) => Preference());
      case '/topics_talk':
        return MaterialPageRoute(builder: (context) => TopicsTalk());
      case '/configuration':
        return MaterialPageRoute(
            builder: (context) =>
                ConfigurationPage(arg['userId'], arg['userInfo']));
      case '/topics_to_hear':
        return MaterialPageRoute(builder: (context) => TopicsHear(
            arg['segments']
        ));
    }

    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
