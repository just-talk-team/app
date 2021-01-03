import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_talk/models/topic.dart';
import 'package:tuple/tuple.dart';

class TopicsService {
  FirebaseFirestore _firebaseFirestore;

  TopicsService({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Tuple2<Topic, bool>>> getTopicsToHear(String segment) {
    CollectionReference segmentCollection =
        _firebaseFirestore.collection("segments");
    return segmentCollection
        .doc(segment)
        .collection('topics')
        .orderBy('time', descending: true)
        .snapshots()
        .map<List<Tuple2<Topic, bool>>>((event) {
      List<Tuple2<Topic, bool>> topics = [];
      event.docChanges.forEach((DocumentChange documentChange) {
        DateTime docDate = documentChange.doc.data()['time'].toDate();
        //TODO: TEST
        //if (DateTime.now().difference(docDate).inMinutes <= 5) {
        Topic topic = Topic(documentChange.doc.id, docDate);
        bool flag = false;
        if (documentChange.type == DocumentChangeType.added ||
            documentChange.type == DocumentChangeType.modified) {
          flag = true;
        }
        topics.add(Tuple2(topic, flag));
        //}
      });
      return topics;
    });
  }

  Future<List<String>> getChatTopics(String user1, String user2) async {
    CollectionReference user1Topics = _firebaseFirestore
        .collection('users')
        .doc(user1)
        .collection('topics_hear');
    CollectionReference user2Topics = _firebaseFirestore
        .collection('user')
        .doc(user2)
        .collection('topics_talk');

    List<QuerySnapshot> collections =
        await Future.wait([user1Topics.get(), user2Topics.get()]);

    List<String> topics = [];
    collections[0].docs.forEach((QueryDocumentSnapshot document) {
      if (collections[1].docs.any((element) => element.id == document.id)) {
        topics.add(document.id);
      }
    });
    return topics;
  }
}
