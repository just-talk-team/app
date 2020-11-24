import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/services/user_service.dart';

void main() {
  UserService userService;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;

  setUpAll(() async {
    firebaseFirestore = MockFirestoreInstance();
    firebaseStorage = MockFirebaseStorage();
    userService = UserService(
        firebaseFirestore: firebaseFirestore, firebaseStorage: firebaseStorage);

    await firebaseFirestore.collection('users').doc('test_user').set({
      'uid': 'test user',
    });
  });

  test('Set topics to hear', () async {
    //arrange
    Topic topic = Topic('example', DateTime.now());

    List<Topic> topics = [topic];
    List<Topic> results = [];

    //execute
    userService.setTopicsToHear(topics, 'test_user');

    //verify
    await firebaseFirestore
        .collection('users')
        .doc('test_user')
        .collection('topics_hear')
        .get()
        .then((QuerySnapshot documentSnapshot) {
      var docs = documentSnapshot.docs;

      docs.forEach((element) {
        results.add(Topic(element.id, element.data()['time'].toDate()));
      });
    });

    expect(results.length, 1);
  });

  test('Listen to new discoveries', () async {
    //arrange
    Stream<QuerySnapshot> discoveries = userService.getDiscoveries('test_user');

    discoveries.listen((QuerySnapshot querySnapshot) {
      querySnapshot.docChanges.forEach((element) => print(element.doc.id));
    });

    //execute
    await firebaseFirestore
        .collection('users')
        .doc('test_user')
        .collection('discoveries')
        .doc('test_discovery')
        .set({'field': 0});
    //verify
  });
}
