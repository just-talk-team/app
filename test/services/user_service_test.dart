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

  setUpAll(() {
    firebaseFirestore = MockFirestoreInstance();
    firebaseStorage = MockFirebaseStorage();
    userService = UserService(
        firebaseFirestore: firebaseFirestore, firebaseStorage: firebaseStorage);
  });

  test('Set topics to hear', () async {
    
    //arrange
    Topic topic = Topic('example', DateTime.now());
    await firebaseFirestore.collection('users').doc('test user').set({
      'uid': 'test user',
    });

    List<Topic> topics = [topic];
    List<Topic> results = [];

    //execute
    userService.setTopicsToHear(topics, 'test user');

    //verify
    await firebaseFirestore
        .collection('users')
        .doc('test user')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      var data = documentSnapshot.data();

      Map<String, dynamic> topics = data['topics_hear'];

      topics.forEach((key, value) {
        results.add(Topic(key, value['time'].toDate()));
      });
    });

    expect(results.length, 1);
  });
}
