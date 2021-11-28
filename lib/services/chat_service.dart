import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> chatMessages(String chatCollection, String roomId) {
  return FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("messages")
      .orderBy("time", descending: false)
      .snapshots();
}

void sendMessage(
    String text, String userId, String roomId, String chatCollection) async {
  Map<String, dynamic> message = {
    'user': userId,
    'message': text.toString(),
    'time': DateTime.now().millisecondsSinceEpoch
  };
  FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("messages")
      .add(message);
}

Stream<bool> getUserState(String userId, String roomId, String chatCollection) {
  return FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("users")
      .doc(userId)
      .snapshots()
      .map((DocumentSnapshot documentSnapshot) =>
          documentSnapshot.data()["state"]);
}

Stream<bool> getMoreMinutes(
    String userId, String roomId, String chatCollection) {
  return FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("users")
      .doc(userId)
      .snapshots()
      .map((DocumentSnapshot documentSnapshot) =>
          documentSnapshot.data()["extends"]);
}

void setUserState(
    String userId, String roomId, String chatCollection, bool state) {
  FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("users")
      .doc(userId)
      .update({'state': state});
}

void setMoreMinutes(
    String userId, String roomId, String chatCollection, bool state) {
  FirebaseFirestore.instance
      .collection(chatCollection)
      .doc(roomId)
      .collection("users")
      .doc(userId)
      .update({'extends': state});
}
