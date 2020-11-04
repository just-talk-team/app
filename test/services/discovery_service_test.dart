import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/services/discovery_service.dart';

void main() {
  DiscoveryService discoveryService;
  FirebaseFirestore firebaseFirestore;

  setUp(() {
    firebaseFirestore = MockFirestoreInstance();
    discoveryService = DiscoveryService(firebaseFirestore: firebaseFirestore);
  });

  test('Activate user', () async {
    //arrange
    await firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc('example')
        .set({'activated': false});

    //execute
    discoveryService.activateUser('example', 'example');

    //verify
    Map<String, dynamic> data;
    await firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc('example')
        .get()
        .then((value) {
      data = value.data();
    });
    expect(data['activated'], true);
  });

  test('Activate room', () async {

    //arrange
    await firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc('example1')
        .set({'activated': true});

    await firebaseFirestore
        .collection('discoveries')
        .doc('example')
        .collection('users')
        .doc('example2')
        .set({'activated': false});

    StreamSubscription<QuerySnapshot> stream = discoveryService
        .getRoom('example')
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        expect(element.data()['activated'], true);
      });
    });

    //execute
    await discoveryService.activateUser('example', 'example2');

    //verif
  });
}
