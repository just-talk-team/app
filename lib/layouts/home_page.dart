import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/services/user_service.dart';

class HomePage extends StatefulWidget {
  HomePage(this._index, this._navbarCubit);

  final int _index;
  final NavbarCubit _navbarCubit;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'JustTalk',
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.build),
              onPressed: () {
                Navigator.of(context).pushNamed('/preferences');
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () =>
                  BlocProvider.of<AuthenticationCubit>(context).logOut(),
            ),
          ],
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Conversa al instante con personas que quieren escucharte!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Builder(builder: (context) {
              if (!loading) {
                return RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  color: Color(0xFFB31048),
                  label: Text(
                    'Just Talk',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  icon: Icon(Icons.sentiment_very_satisfied_rounded,
                      color: Colors.white, size: 35),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    String id = BlocProvider.of<AuthenticationCubit>(context)
                        .state
                        .user
                        .id;
                    List<String> segments =
                        await RepositoryProvider.of<UserService>(context)
                            .getSegments(id);

                    Preferences preferences =
                        await RepositoryProvider.of<UserService>(context)
                            .getPreferences(id);

                    if (preferences.segments.length > 0) {
                      await Navigator.of(context).pushNamed('/topics_talk',
                          arguments: {'segments': segments});
                    } else {
                      Flushbar(
                        backgroundColor: Color(0xFFB31048),
                        flushbarPosition: FlushbarPosition.TOP,
                        messageText: Text(
                          'Debes de seleccionar al menos un segmento!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        duration: Duration(seconds: 3),
                      ).show(context);
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            })
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_very_satisfied_rounded),
              label: 'Just Talk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded),
              label: 'Amigos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Mi perfil',
            ),
          ],
          currentIndex: widget._index,
          onTap: (index) {
            switch (index) {
              case 0:
                widget._navbarCubit.toHome();
                break;
              case 1:
                widget._navbarCubit.toContacts();
                break;
              case 2:
                widget._navbarCubit.toProfile();
                break;
            }
          },
        ),
      ),
    );
  }
}
