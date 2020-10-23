import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_talk/layouts/preferences_page.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/utils/enums.dart';

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

    List<String> segmentsStated = [];

    DocumentReference newUser =
        FirebaseFirestore.instance.collection("users").doc(userId);

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
        'segments': FieldValue.arrayUnion(segmentsStated),
        //'genders': {'women': 0, 'men': 0},
        'genders': FieldValue.arrayUnion([])
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

  Future<UserInfo> getUser(String id, String email) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(id);

    Preferences preference;
    UserInfo user;

    return await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();

        List<String> segmentsDomain =
            data['preferences']['segments'].cast<String>();
        List<String> segments = [];

        segmentsDomain.forEach((element) async {
          await userDoc
              .collection('segments')
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
              var data = queryDocumentSnapshot.data();
              segments.add(data['email']);
            });
          });
        });

        preference = Preferences(
            maximumAge: data['preferences']['ages']['maximun'],
            minimunAge: data['preferences']['ages']['minimun'],
            genders: EnumToString.fromList(
                Gender.values, data['preferences']['genders']),
            segments: segments);

        DateTime birthday = data['birthday'].toDate();
        int age = (birthday.difference(DateTime.now()).inDays / 365).truncate();

        user = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: preference,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthday: birthday);

        return user;
      }
      return UserInfo.empty;
    });
  }
}
