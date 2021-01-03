import 'package:flutter/material.dart';
import 'package:just_talk/layouts/configuration.dart';
import 'package:just_talk/layouts/friend_filter.dart';
import 'package:just_talk/layouts/home.dart';
import 'package:just_talk/layouts/login.dart';
import 'package:just_talk/layouts/preferences_page.dart';
import 'package:just_talk/layouts/profile.dart';
import 'package:just_talk/layouts/register.dart';
import 'package:just_talk/layouts/splash.dart';
import 'package:just_talk/layouts/topics_hear.dart';
import 'package:just_talk/layouts/topics_talk.dart';

import 'layouts/chat.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map arg = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => Splash(), settings: RouteSettings(name: '/'));
      case '/home':
        return MaterialPageRoute(
            builder: (context) => Home(),
            settings: RouteSettings(name: '/home'));
      case '/login':
        return MaterialPageRoute(
            builder: (context) => Login(),
            settings: RouteSettings(name: '/login'));
      case '/register':
        return MaterialPageRoute(
            builder: (context) => Register(),
            settings: RouteSettings(name: '/register'));
      case '/preferences':
        return MaterialPageRoute(
            builder: (context) => Preference(),
            settings: RouteSettings(name: '/preferences'));
      case '/topics_talk':
        return MaterialPageRoute(
            builder: (context) => TopicsTalk(),
            settings: RouteSettings(name: '/topics_talk'));
      case '/configuration':
        return MaterialPageRoute(
            builder: (context) => ConfigurationPage(
                  userId: arg['userId'],
                  userInfo: arg['userInfo'],
                  userService: arg['userService'],
                ),
            settings: RouteSettings(name: '/configuration'));
      case '/topics_to_hear':
        return MaterialPageRoute(
            builder: (context) => TopicsHear(arg['segments']),
            settings: RouteSettings(name: '/topics_to_hear'));
      case '/filters':
        return MaterialPageRoute(
            builder: (context) => FriendFilter(),
            settings: RouteSettings(name: '/filters'));
      case '/chat':
        return MaterialPageRoute(
            builder: (context) => Chat(
                  roomId: arg['roomId'],
                  chatType: arg['chatType'],
                ),
            settings: RouteSettings(name: '/chat'));
      case '/chat_profile':
        return MaterialPageRoute(builder: (context) => Profile(
          userId: arg['userId'],
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
