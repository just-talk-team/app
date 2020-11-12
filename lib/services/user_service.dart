import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/models/user.dart';
import 'package:just_talk/models/topics.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/models/user_profile.dart';
import 'package:just_talk/utils/enums.dart';

class UserService {
  UserService(
      {FirebaseFirestore firebaseFirestore, FirebaseStorage firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  FirebaseFirestore _firebaseFirestore;
  FirebaseStorage _firebaseStorage;

  Future<void> registrateUser(UserInput userI, String userId) async {
    final StorageReference postImageRef =
        _firebaseStorage.ref().child("UserProfile");
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
      'gender': describeEnum(userI.genre),
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
    DocumentReference userDoc = _firebaseFirestore.collection("users").doc(id);

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
            querySnapshot.docs
                .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
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

  Future<UserProfile> getUserInfoProfile(String id) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(id);
    List<String> badgets = [];
    List<String> segments = [];
    List<String> topicsTalk = [];
    List<String> topicsHear = [];

    await userDoc
        .collection('segments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          var data = queryDocumentSnapshot.data();
          if (data['validate'] == true) {
            segments.add(data.toString());
          }
        });
      }
    });
    await userDoc
        .collection('badgets')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          var data = queryDocumentSnapshot.data();
          badgets.add(data.toString());
        });
      }
    });
    await userDoc
        .collection('topics_talk')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          var data = queryDocumentSnapshot.data();
          topicsTalk.add(data.toString());
        });
      }
    });
    await userDoc
        .collection('topics_hear')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          var data = queryDocumentSnapshot.data();
          topicsHear.add(data.toString());
        });
      }
    });

    return UserProfile(
        badgets: badgets,
        segments: segments,
        topicsHear: topicsHear,
        topicsTalk: topicsTalk);
  }
  Future<List<String>> getSegments(String id) async {
    List<String> segments = [];

    CollectionReference segmentCollection =
        _firebaseFirestore.collection("users").doc(id).collection('segments');

    await segmentCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        segments.add(element.id);
      });
    });
    return segments;
  }

  Future setTopicsToHear(List<Topic> topics, String id) async {
    DocumentReference user = _firebaseFirestore.collection("users").doc(id);

    Map<String, dynamic> topicsMap = Map();
    for (Topic topic in topics) {
      topicsMap[topic.topic] = {'time': DateTime.now()};
    }

    if (topicsMap.length > 0) {
      await user.update({'topics_hear': topicsMap});
    }
  }

  Stream<QuerySnapshot> getDiscoveries(String id) {
    return _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('discoveries')
        .snapshots();
  }

  Future<List<Topic>> setTopicsTalk(String id, List<Topic> topics ) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_talk');

    for (Topic topic in topics){
      await topicTalkCollection.doc(topic.topic).set({
          'time': topic.time
     });
    }

  }

  Future<List<Topic>> getTopicsTalk(String id) async {
    List<Topic> topics = [ ];

    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_talk');

    await topicTalkCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        topics.add(Topic(element.id, element.data()['time'].toDate()));
      });
    });
    return topics;
  }

  Future<List<Topic>> deleteTopicsTalk(String id, List<Topic> topics ) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_talk');

    for (Topic topic in topics){
      await topicTalkCollection.doc(topic.topic).delete();
    }
  }

}
