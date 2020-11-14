import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:just_talk/services/authentication_service.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements auth.User {}

class MockFacebookLogin extends Mock implements FacebookLogin {}

class MockFacebookLoginResult extends Mock implements FacebookLoginResult {}

class MockAuthCredential extends Mock implements auth.AuthCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockFirebase extends Mock implements Firebase {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

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

  group('getting preferences', () {
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
    test('signInWithCredential method is called', () async {
      final auth.AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: '',
        idToken: googleAuth.idToken,
      );
      await authenticationService.logInWithCredentials(credential);
      verify(authenticationService.logInWithCredentials(any)).called(1);
    });

    test('Recover info', () async {
      RangeValues _currentRangeValues = RangeValues(18, 70);

      var uid = 'ruuGzjupvRdVakpRblsyTP0yC0n1';
      var ages = [20.0, 30.0];
      var gender = ['men', 'women'];
      var insignias = [1, 0, 1];
      var _genderList = [];
      var _loadedRegisteredSegments = [
        'Sin segmentación',
        'upc.edu.pe',
        'vizcarra-mi-bono.com'
      ];

      var _lowerValue = ages[0];
      var _upperValue = ages[1];

      _currentRangeValues = RangeValues(_lowerValue, _upperValue);

      gender.forEach((element) {
        _genderList.add(element);
      });

      var _funny = insignias[0];
      var _goodListener = insignias[1];
      var _goodTalker = insignias[2];

      expect(_loadedRegisteredSegments[0], 'Sin segmentación');
      expect(_lowerValue, ages[0]);
      expect(_upperValue, ages[1]);
      expect(_funny, insignias[0]);
      expect(_goodListener, insignias[1]);
      expect(_goodTalker, insignias[2]);
    });

    test('Save info', () {
      RangeValues _currentRangeValues = RangeValues(18, 70);
      var insignias = [1, 0, 1];

      var _segmentsSelected = ['Sin segmentación'];
      var _multipleSelected = ['women'];
      documentReference.update({
        'preferences': {
          'segments': FieldValue.arrayUnion(_segmentsSelected),
          'ages': {
            'minimun': _currentRangeValues.start.toInt(),
            'maximun': _currentRangeValues.end.toInt()
          },
          //'genders': {'women': womenVal, 'men': menVal},
          'genders': FieldValue.arrayUnion(_multipleSelected)
        },
        'badgets': {
          'funny': insignias[0],
          'good_listener': insignias[1],
          'good_talker': insignias[2]
        }
      });
    });
  });
}
