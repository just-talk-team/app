import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/route_generator.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/user_service.dart';

class App extends StatelessWidget {
  const App(
      {Key key,
      @required this.authenticationService,
      @required this.userService})
      : assert(authenticationService != null),
        assert(userService != null),
        super(key: key);

  final AuthenticationService authenticationService;
  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationService,
      child: BlocProvider(
          create: (_) => AuthenticationCubit(
              authenticationService: authenticationService,
              userService: userService),
          child: AppView()),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      onGenerateRoute: RouterGenerator.generateRoute,
      builder: (context, child) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            switch (state.authenticationStatus) {
              case AuthenticationStatus.authenticated:
                _navigator.pushReplacementNamed('/home');
                break;
              case AuthenticationStatus.unauthenticated:  
                _navigator.pushNamed('/login');
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.grey[900],
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.black),
    );
  }
}
