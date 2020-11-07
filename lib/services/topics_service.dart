import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_talk/models/topics.dart';

class TopicsService {
  FirebaseFirestore _firebaseFirestore;

  TopicsService({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  List<Topic> _validate(List<Topic> topics) {
    Set<Topic> topicsSet = Set();
    for (Topic element in topics) {
      topicsSet.add(element);
    }
    return topicsSet.toList();
  }

  Future<List<Topic>> getTopicsToHear(List<String> segments) async {
    CollectionReference segmentCollection = _firebaseFirestore.collection("segments");
    List<Topic> topicsToHear = <Topic>[];

    for (String segment in segments) {
      await segmentCollection
          .doc(segment)
          .collection('topics')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.where((QueryDocumentSnapshot queryDocumentSnapshot) {
          return true;
          DateTime lastUpdate = queryDocumentSnapshot.data()['last_update'];
          return DateTime.now().difference(lastUpdate).inMinutes <= 5;
        }).forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          topicsToHear.add(Topic(queryDocumentSnapshot.id,
              queryDocumentSnapshot.data()['last_update'].toDate()));
        });
      });
    }
    return _validate(topicsToHear);
  }
}
