import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/services/user_service.dart';

class HomePage extends StatelessWidget {
  HomePage(this._index, this._navbarCubit);
  
  final int _index;
  final NavbarCubit _navbarCubit;

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
                Navigator.of(context).pushNamed('/preference');
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
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                'Conversa al instante con personas que quieren escucharte! \n :)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: Colors.red[900],
              label: Text(
                'Just Talk',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              icon: Icon(
                Icons.sentiment_satisfied,
                color: Colors.white,
              ),
              onPressed: () async {
                String id =
                    BlocProvider.of<AuthenticationCubit>(context).state.user.id;
                List<String> segments =
                    await RepositoryProvider.of<UserService>(context)
                        .getSegments(id);
                        
                Navigator.of(context).pushNamed(
                    '/topics_to_hear',
                    arguments: {'segments': segments});
              },
            )
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_satisfied),
              title: Text('Just Talk'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('Amigos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Mi perfil'),
            ),
          ],
          currentIndex: _index,
          onTap: (index) {
            switch (index) {
              case 0:
                _navbarCubit.toHome();
                break;
              case 1:
                _navbarCubit.toContacts();
                break;
              case 2:
                _navbarCubit.toProfile();
                break;
            }
          },
        ),
      ),
    );
  }
}
