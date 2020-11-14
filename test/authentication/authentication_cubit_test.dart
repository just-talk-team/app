import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/authentication/authentication.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticacionService extends Mock implements AuthenticationService {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

void main() {
  final user = MockUser();
  AuthenticationService authenticationService;

  setUp(() {
    authenticationService = MockAuthenticacionService();
    when(authenticationService.user).thenAnswer((_) => const Stream.empty());
  });

  group('AuthenticationCubit', () {
    test('Error response when AuthenticationService is null', () {
      expect(() => AuthenticationCubit(authenticationService: null),
          throwsAssertionError);
    });

    test('The initial states is AuthenticationState.unknown', () {
      final authenticationCubit =
          AuthenticationCubit(authenticationService: authenticationService);
      expect(authenticationCubit.state, const AuthenticationState.unknown());
      authenticationCubit.close();
    });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'A user is added to the stream',
      build: () {
        when(authenticationService.user).thenAnswer((_) => Stream.value(user));
        return AuthenticationCubit(
            authenticationService: authenticationService);
      },
      expect: <AuthenticationState>[
        AuthenticationState.authenticated(user),
      ],
    );

    group('AuthenticationUserChanged', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'Log [authenticate] when the user model is not null',
        build: () =>
            AuthenticationCubit(authenticationService: authenticationService),
        act: (cubit) => cubit.mapAuthenticationUserChangedToState(
            AuthenticationUserChanged(user)),
        expect: <AuthenticationState>[AuthenticationState.authenticated(user)],
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'log [unauthenticated] when the user model is',
        build: () =>
            AuthenticationCubit(authenticationService: authenticationService),
        act: (cubit) => cubit.mapAuthenticationUserChangedToState(
            AuthenticationUserChanged(User.empty)),
        expect: <AuthenticationState>[AuthenticationState.unauthenticated()],
      );
    });

    group('Logout', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
          'Logout method from AuthenticationSerive is called',
          build: () =>
              AuthenticationCubit(authenticationService: authenticationService),
          act: (cubit) => cubit.logOut(),
          verify: (_) {
            verify(authenticationService.logOut()).called(1);
          });
    });
  });
}
