part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus authenticationStatus;
  final User user;

  const AuthenticationState._(
      {this.authenticationStatus = AuthenticationStatus.unknown, this.user});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(
            authenticationStatus: AuthenticationStatus.authenticated,
            user: user);

  const AuthenticationState.unauthenticated()
      : this._(authenticationStatus: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [authenticationStatus, user];
}
