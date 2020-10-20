import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/route_generator.dart';
import 'package:just_talk/services/authentication_service.dart';

class App extends StatelessWidget {
  App({Key key, @required this.authenticationService})
      : assert(authenticationService != null),
        super(key: key);

  final AuthenticationService authenticationService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationService,
      child: BlocProvider(
          create: (_) =>
              AuthenticationCubit(authenticationService: authenticationService),
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

  Future<bool> register(String userId) async {
    bool result = false;
    var doc = FirebaseFirestore.instance.collection('users');

    var querySnapshot =
        await doc.limit(1).where('uid', isEqualTo: userId).get();

    querySnapshot.docs.forEach((element) {
      result = element.exists;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      onGenerateRoute: RouterGenerator.generateRoute,
      builder: (context, child) {
        return BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) async {
            switch (state.authenticationStatus) {
              case AuthenticationStatus.authenticated:
                bool result = await register(state.user.id);
                if (result) {
                  _navigator.pushReplacementNamed('/home');
                  break;
                }
                _navigator.pushReplacementNamed('/register');
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushReplacementNamed('/login');
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
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'ArialRounded',
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black))),
    );
  }
}
