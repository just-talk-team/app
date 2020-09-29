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
    test('Resulta en error cuando AuthenticationService es nulo', () {
      expect(() => AuthenticationCubit(authenticationService: null),
          throwsAssertionError);
    });

    test('El estado inicial es AuthenticationState.unknown', () {
      final authenticationCubit =
          AuthenticationCubit(authenticationService: authenticationService);
      expect(authenticationCubit.state, const AuthenticationState.unknown());
      authenticationCubit.close();
    });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'Un usuario se añade al stream',
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
        'Emite [authenticate] cuando el usuario no es nulo',
        build: () =>
            AuthenticationCubit(authenticationService: authenticationService),
        act: (cubit) => cubit.mapAuthenticationUserChangedToState(
            AuthenticationUserChanged(user)),
        expect: <AuthenticationState>[AuthenticationState.authenticated(user)],
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'Emite [unauthenticated] cuando el usuario esta vacio',
        build: () =>
            AuthenticationCubit(authenticationService: authenticationService),
        act: (cubit) => cubit.mapAuthenticationUserChangedToState(
            AuthenticationUserChanged(User.empty)),
        expect: <AuthenticationState>[AuthenticationState.unauthenticated()],
      );
    });

    group('Logout', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
          'Se llama al metodo logout de AuthenticationService',
          build: () =>
              AuthenticationCubit(authenticationService: authenticationService),
          act: (cubit) => cubit.logOut(),
          verify: (_) {
            verify(authenticationService.logOut()).called(1);
          }
      );
    });
    
  });
}
