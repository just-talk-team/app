part of 'navbar_cubit.dart';

class NavBarState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeState extends NavBarState {
  final int index = 0;

  @override
  List<Object> get props => [index];
}

class ContactState extends NavBarState {
  final int index = 1;

  @override
  List<Object> get props => [index];
}

class ProfileState extends NavBarState {
  final int index = 2;

  @override
  List<Object> get props => [index];
}


