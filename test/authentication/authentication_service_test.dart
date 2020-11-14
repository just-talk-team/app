import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:mockito/mockito.dart';

class MockFacebookSignIn extends Mock implements FacebookLogin {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() async {
  FirebaseAuth firebaseAuth;
  AuthenticationService authenticationService;
  FacebookLogin facebookLogin;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    facebookLogin = MockFacebookSignIn();
    authenticationService = AuthenticationService(
        firebaseAuth: firebaseAuth, facebookLogin: facebookLogin);
  });
  group('Login with a Facebook account', () {
    MockGoogleSignIn googleSignIn;
    MockGoogleSignInAccount signinAccount;
    MockGoogleSignInAuthentication googleAuth;

    setUp(() async {
      googleSignIn = MockGoogleSignIn();
      signinAccount = await googleSignIn.signIn();
      googleAuth = await signinAccount.authentication;
    });

    test('signInWithCredential method is called', () async {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: '',
        idToken: googleAuth.idToken,
      );
      await authenticationService.logInWithCredentials(credential);
      verify(firebaseAuth.signInWithCredential(any)).called(1);
    });

    test('SignIn', () async {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: '',
        idToken: googleAuth.idToken,
      );
      expect(authenticationService.logInWithCredentials(credential), completes);
    });
  });
}
