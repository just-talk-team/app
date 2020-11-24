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
}
