import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/bloc/navbar_cubit.dart';

void main() {
  test('El estado inicial es HomeState', () {
    final navbarCubit = NavbarCubit();
    expect(navbarCubit.state, HomeState());
    navbarCubit.close();
  });
  group('NavbarCubit state', () {
    blocTest<NavbarCubit, NavBarState>(
      'NavbarCubit navigation to home',
      build: () => NavbarCubit(),
      act: (cubit) => cubit.toHome(),
      expect: <NavBarState>[HomeState()],
    );
  });
}
