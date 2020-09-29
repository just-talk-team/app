import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';
import 'package:just_talk/widgets/home_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavbarCubit _navbarCubit;

  @override
  void initState() {
    super.initState();
    _navbarCubit = NavbarCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarCubit, NavBarState>(
      cubit: _navbarCubit,
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeState:
            return HomePage(0, _navbarCubit);
          default:
            return HomePage(0, _navbarCubit);
        }
      },
    );
  }
}
