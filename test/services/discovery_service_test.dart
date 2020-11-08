import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/services/discovery_service.dart';

void main() {
  DiscoveryService discoveryService;
  FirebaseFirestore firebaseFirestore;
  StreamSubscription<QuerySnapshot> stream;

  setUp(() {
    firebaseFirestore = MockFirestoreInstance();
    discoveryService = DiscoveryService(firebaseFirestore: firebaseFirestore);
  });

  Future<void> createUser(String id, bool activated) async {
    await firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc(id)
        .set({'activated': activated});
  }

  Future<DocumentSnapshot> getUser(String id) {
    return firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc(id)
        .get();
  }

  test('Activate user', () async {
    //arrange
    createUser('example', false);

    //execute
    discoveryService.activateUser('example', 'example');

    //verify
    DocumentSnapshot documentSnapshot = await getUser('example');
    Map<String, dynamic> data = documentSnapshot.data();
    expect(data['activated'], true);
  });

  test('Activate room', () async {
    //arrange
    createUser('example1', true);
    createUser('example2', false);

    stream = discoveryService
        .getRoom('example')
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        expect(element.data()['activated'], true);
      });
    });

    //execute
    await discoveryService.activateUser('example', 'example2');

    //verify
  });

  tearDownAll(() {
    stream.cancel();
  });
}
