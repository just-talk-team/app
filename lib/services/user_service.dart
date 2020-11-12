import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/models/user_profile.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:tuple/tuple.dart';

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

    DocumentReference newUser =
        FirebaseFirestore.instance.collection("users").doc(userId);

    await newUser.set({
      'uid': userId,
      'avatar': url,
      'birthday': userI.dateTime,
      'friends': {},
      'gender': describeEnum(userI.genre),
      'nickname': userI.nickname,
      'preferences': {
        'ages': {
          'minimun': 18,
          'maximun': 99,
        },
        'segments': FieldValue.arrayUnion([]),
        //'genders': {'women': 0, 'men': 0},
        'genders': FieldValue.arrayUnion([]),
        'badgets': FieldValue.arrayUnion([]),
      },
      'filters': {
        'ages': {
          'minimun': 18,
          'maximun': 99,
        },
        'segments': FieldValue.arrayUnion([]),
        //'genders': {'women': 0, 'men': 0},
        'genders': FieldValue.arrayUnion([]),
        'badgets': FieldValue.arrayUnion([]),
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

    badgets.forEach((element) async {
      await newUser.collection('badgets').doc(element.item1).set({'count': 0});
    });
  }

  Future<UserInfo> getUser(
      String id, bool preferencesFlag, bool filtersFlag) async {
    DocumentReference userDoc = _firebaseFirestore.collection("users").doc(id);
    Preferences preferences = Preferences.empty();
    Preferences filters = Preferences.empty();
    UserInfo user;

    return await userDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();

        if (preferencesFlag) {
          preferences = Preferences(
              maximumAge: data['preferences']['ages']['maximun'],
              minimunAge: data['preferences']['ages']['minimun'],
              genders: EnumToString.fromList(
                  Gender.values, data['preferences']['genders']),
              segments: data['preferences']['segments'].cast<String>(),
              badgets: data['preferences']['badgets'].cast<String>());
        }

        if (filtersFlag) {
          filters = Preferences(
              maximumAge: data['filters']['ages']['maximun'],
              minimunAge: data['filters']['ages']['minimun'],
              genders: EnumToString.fromList(
                  Gender.values, data['filters']['genders']),
              segments: data['filters']['segments'].cast<String>(),
              badgets: data['filters']['badgets'].cast<String>());
        }

        DateTime birthday = data['birthday'].toDate();
        int age = (birthday.difference(DateTime.now()).inDays / 365).truncate();

        user = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: preferences,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthday: birthday,
            filters: filters,
            id: id);

        return user;
      }
      return UserInfo.empty();
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
            segments.add(queryDocumentSnapshot.id.toString());
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
          var data = queryDocumentSnapshot.id;
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
          var data = queryDocumentSnapshot.id;
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

  Future<Map<String, int>> getBadgets(String id) async {
    Map<String, int> badgets = {};

    CollectionReference segmentCollection =
        _firebaseFirestore.collection("users").doc(id).collection('badges');

    await segmentCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        badgets[element.id] = element.data()['count'];
      });
    });
    return badgets;
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

  bool _validateSegment(List<String> preferenceSegment, List<String> segments) {
    if (preferenceSegment.length == 0) {
      return true;
    }
    for (String preference in preferenceSegment) {
      if (!segments.contains(preference)) {
        return false;
      }
    }
    return true;
  }

  bool _validateBadgets(
      List<String> preferenceBadgets, Map<String, int> badgets) {
    if (preferenceBadgets.length == 0) {
      return true;
    }
    for (String preference in preferenceBadgets) {
      if (badgets[preference] == 0) {
        return false;
      }
    }
    return true;
  }

  bool _validateGender(List<Gender> preferenceGenre, Gender gender) {
    if (preferenceGenre.length == 0) {
      return true;
    }
    if (preferenceGenre.contains(gender)) {
      return true;
    }
    return false;
  }

  Future<Preferences> getFilters(String id) async {
    var data = await _firebaseFirestore.collection('users').doc(id).get();
    return Preferences(
        maximumAge: data.data()['filters']['ages']['maximun'],
        minimunAge: data.data()['filters']['ages']['minimun'],
        genders: EnumToString.fromList(
            Gender.values, data.data()['filters']['genders']),
        segments: data.data()['filters']['segments'].cast<String>(),
        badgets: data.data()['filters']['badgets'].cast<String>());
  }

  Future<List<Tuple2<UserInfo, String>>> getFilteredValidatedContacts(
      String id) async {
    List<String> usersRoom = [];
    List<Tuple2<UserInfo, String>> contacts = [];
    Preferences filter = await getFilters(id);

    await _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        usersRoom.add(element.id);
      });
    });

    for (String userRoom in usersRoom) {
      var doc = await _firebaseFirestore
          .collection('friends')
          .doc(userRoom)
          .collection('users')
          .where((element) => element.id != id)
          .get();

      if (doc != null && doc.docs.length > 0) {
        String contactId = doc.docs[0].id;

        var userInfo = await getUser(contactId, true, true);
        var segments = await getSegments(contactId);
        var badgets = await getBadgets(contactId);

        if (userInfo.age >= filter.minimunAge &&
            userInfo.age <= filter.maximumAge &&
            _validateSegment(filter.segments, segments) &&
            _validateBadgets(filter.badgets, badgets) &&
            _validateGender(filter.genders, userInfo.gender)) {
          contacts.add(Tuple2(userInfo, userRoom));
        }
      }
    }
    return contacts;
  }

  Stream<QuerySnapshot> getLastMessage(String roomId) {
    return _firebaseFirestore
        .collection('friends')
        .doc(roomId)
        .collection('messages')
        .orderBy('time')
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getDiscoveries(String id) {
    return _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('discoveries')
        .snapshots();
  }

  Future<void> setTopicsTalk(String id, List<Topic> topics) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_talk');

    for (Topic topic in topics) {
      await topicTalkCollection.doc(topic.topic).set({'time': topic.time});
    }
  }

  Future<List<Topic>> getTopicsTalk(String id) async {
    List<Topic> topics = [];

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

  Future<void> deleteTopicsTalk(String id, List<Topic> topics) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_talk');

    for (Topic topic in topics) {
      await topicTalkCollection.doc(topic.topic).delete();
    }
  }

  Future<void> updatePreferences(String id, Preferences preferences) async {
    DocumentReference user = _firebaseFirestore.collection("users").doc(id);
    await user.update({
      'preferences': {
        'ages': {
          'maximun': preferences.maximumAge,
          'minimun': preferences.minimunAge
        },
        'genders': FieldValue.arrayUnion(
            EnumToString.toList<Gender>(preferences.genders)),
        'segments': FieldValue.arrayUnion(preferences.segments),
        'badgets': FieldValue.arrayUnion(preferences.badgets)
      }
    });
  }

  Future<void> updateFriendFilters(String id, Preferences preferences) async {
    DocumentReference user = _firebaseFirestore.collection("users").doc(id);
    await user.update({
      'filters': {
        'ages': {
          'maximun': preferences.maximumAge,
          'minimun': preferences.minimunAge
        },
        'genders': FieldValue.arrayUnion(
            EnumToString.toList<Gender>(preferences.genders)),
        'segments': FieldValue.arrayUnion(preferences.segments),
        'badgets': FieldValue.arrayUnion(preferences.badgets)
      }
    });
  }
}
