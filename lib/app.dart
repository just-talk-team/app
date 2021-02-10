import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/route_generator.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:just_talk/services/remote_service.dart';
import 'package:just_talk/services/user_service.dart';

class App extends StatelessWidget {
  App(
      {Key key,
      @required this.authenticationService,
      @required this.remoteService})
      : assert(authenticationService != null),
        assert(remoteService != null),
        super(key: key);

  final AuthenticationService authenticationService;
  final RemoteService remoteService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationService,
      child: BlocProvider(
          create: (_) =>
              AuthenticationCubit(authenticationService: authenticationService),
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UserService>(
                  create: (context) => UserService()),
              RepositoryProvider<RemoteService>.value(value: remoteService)
            ],
            child: AppView(),
          )),
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

    result = (querySnapshot.docs.length == 1);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: RouterGenerator.generateRoute,
        builder: (context, child) {
          return BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) async {
              switch (state.authenticationStatus) {
                case AuthenticationStatus.authenticated:
                  bool result = await register(state.user.id);
                  if (result) {
                    _navigator.pushReplacementNamed('/register');
                    break;
                  }
                  _navigator.pushReplacementNamed('/register');
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        theme: ThemeData(
            primaryColor: Color(0xffff2424),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'ArialRounded',
            accentColor: Color(0xffff2424).withOpacity(0.7),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              unselectedIconTheme:
                  IconThemeData(color: Colors.black.withOpacity(0.5)),
              selectedIconTheme: IconThemeData(color: Colors.black),
              selectedItemColor: Colors.black,
            ),
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                elevation: 0,
                color: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                textTheme: TextTheme(
                    headline6: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black))),
            textTheme: TextTheme(
                headline6:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                bodyText1:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                caption: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black))));
  }
}
