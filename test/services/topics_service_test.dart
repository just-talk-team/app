import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_talk/services/topics_service.dart';

void main() {
  TopicsService topicsService;
  FirebaseFirestore firebaseFirestore;
  List<String> segments;

  setUp(() async {
    segments = ['hotmail.com', 'gmail.com'];
    firebaseFirestore = MockFirestoreInstance();
    topicsService = TopicsService(firebaseFirestore: firebaseFirestore);

    for (String segment in segments) {
      await firebaseFirestore
          .collection('segments')
          .doc(segment)
          .collection('topics')
          .doc('example')
          .set({'last_update': DateTime.now()});
    }
  });
}
