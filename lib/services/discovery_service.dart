import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoveryService {
  DiscoveryService({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<QuerySnapshot> getRoom(String roomId) {
    return _firebaseFirestore
        .collection('discoveries')
        .doc(roomId)
        .collection('users')
        .snapshots();
  }

  Future<void> activateUser(String roomId, String userId) async {
    await _firebaseFirestore
        .collection('discoveries')
        .doc(roomId)
        .collection('users')
        .doc(userId)
        .update({'activated': true});
  }
}
