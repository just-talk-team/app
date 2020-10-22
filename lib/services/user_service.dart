import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_talk/models/user_input.dart';

class UserService {

  Future<void> registrateUser(UserInput userI, String userId) async {
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("UserProfile");
    var timeKey = DateTime.now();
    final StorageUploadTask uploadTask = postImageRef
        .child(timeKey.toString() + ".jpg")
        .putFile(userI.imgProfile);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();

    List<String> domains = [];
    userI.segments.forEach((element) {
      domains.add(element.item2);
    });

    DocumentReference newUser = FirebaseFirestore.instance.collection("users").doc(userId);

    await newUser.set({
      'uid': userId,
      'avatar': url,
      'badgets': {'good_talker': 0, 'good_listener': 0, 'funny': 0},
      'birthday': userI.dateTime,
      'friends': {},
      'gender': userI.genre.toString(),
      'nickname': userI.nickname,
      'preferences': {
        'ages': {
          'minimun': 18,
          'maximun': 99,
        },
        'segments': FieldValue.arrayUnion(domains),
        'genders': {},
      },
      'topics_hear': {},
      'user_type': 'premiun',
    });

    userI.segments.forEach((element) async {
      await newUser
          .collection('segments')
          .doc(element.item2)
          .set({'email': element.item1});
    });
   }
}
