import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:mockito/mockito.dart';

import 'authentication/authentication_service_test.dart';
import 'preferences_test.dart';

class MockFirebaseAuth extends Mock implements auth.FirebaseAuth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  auth.FirebaseAuth firebaseAuth;
  AuthenticationService authenticationService;
  FacebookLogin facebookLogin;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    facebookLogin = MockFacebookLogin();
    authenticationService = AuthenticationService(
        firebaseAuth: firebaseAuth, facebookLogin: facebookLogin);
  });

  group('recover actual chat', () {
    MockGoogleSignIn googleSignIn;
    MockGoogleSignInAccount signinAccount;
    MockGoogleSignInAuthentication googleAuth;
    MockFirebaseFirestore _firestore = MockFirebaseFirestore();
    MockDocumentReference documentReference;

    setUp(() async {
      googleSignIn = MockGoogleSignIn();
      signinAccount = await googleSignIn.signIn();
      googleAuth = await signinAccount.authentication;
      documentReference = MockDocumentReference();
      _firestore = MockFirebaseFirestore();
    });
    test('Llamada al metodo signInWithCredential', () async {
      final auth.AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: '',
        idToken: googleAuth.idToken,
      );
      await authenticationService.logInWithCredentials(credential);
      verify(authenticationService.logInWithCredentials(any)).called(1);
    });

    test('Recover chat messages', () {
      String userId1 = "ruuGzjupvRdVakpRblsyTP0yC0n1", //youId
          userId2 = "uJcO8LqB4dgY8RUTLYHsaa6W5yN2"; //anotherUserId
      String chatId;
      int levelClock = 301;
      Stream chatMessages;
      var chats = [
        ["ruuGzjupvRdVakpRblsyTP0yC0n1", "hello"],
        ["uJcO8LqB4dgY8RUTLYHsaa6W5yN2", "hey"],
      ];
      expect(chats[0][0], userId1);
    });
    test('Send message', () {
      String userId1 = "ruuGzjupvRdVakpRblsyTP0yC0n1";

      var messages = [];

      String text = "hey how are ya";
      Map<String, dynamic> message = {
        'user': userId1,
        'message': text.toString(),
        'time': DateTime.now().millisecondsSinceEpoch
      };
      messages.add(message);

      expect(messages.length, 1);
    });
  });
}
