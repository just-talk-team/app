import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/authentication.dart';

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
        floatingActionButton: BlocBuilder<AuthenticationCubit,AuthenticationState>(
          builder: (context,state) {
            return FloatingActionButton(
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
               ),
              backgroundColor: Colors.black,
              onPressed: () => context.bloc<AuthenticationCubit>().logOut(),
            );
          }
        ),
      ),
    );
  }
}
