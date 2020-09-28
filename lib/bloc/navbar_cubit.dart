import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavBarState> {
  NavbarCubit() : super(HomeState());

  void toHome() {
    emit(HomeState());
  }
}
