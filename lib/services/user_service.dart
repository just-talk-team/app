import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/models/topic.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/models/user_input.dart';
import 'package:just_talk/utils/constants.dart';
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

    final StorageUploadTask uploadTask =
        postImageRef.child(userId + ".jpg").putFile(userI.imgProfile);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();

    DocumentReference newUser =
        FirebaseFirestore.instance.collection("users").doc(userId);

    final DateFormat formatter = DateFormat("MM/dd/yyyy");

    await newUser.set({
      'uid': userId,
      'avatar': url,
      'birthdate': formatter.format(userI.dateTime),
      'friends': {},
      'gender': describeEnum(userI.genre),
      'nickname': userI.nickname,
      'preferences': {
        'ages': [16, 99],
        'segments': FieldValue.arrayUnion([]),
        'genders': FieldValue.arrayUnion([]),
        'badgets': FieldValue.arrayUnion([]),
      },
      'filters': {
        'ages': [16, 99],
        'segments': FieldValue.arrayUnion([]),
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

    badges.forEach((element) async {
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
              minimunAge: data['preferences']['ages'].cast<int>()[0],
              maximumAge: data['preferences']['ages'].cast<int>()[1],
              genders: EnumToString.fromList(
                  Gender.values, data['preferences']['genders']),
              segments: data['preferences']['segments'].cast<String>(),
              badgets: data['preferences']['badgets'].cast<String>());
        }

        if (filtersFlag) {
          filters = Preferences(
              minimunAge: data['filters']['ages'].cast<int>()[0],
              maximumAge: data['filters']['ages'].cast<int>()[1],
              genders: EnumToString.fromList(
                  Gender.values, data['filters']['genders']),
              segments: data['filters']['segments'].cast<String>(),
              badgets: data['filters']['badgets'].cast<String>());
        }

        // MM/dd/yyyy
        String day = data['birthdate'].substring(3, 5);
        String month = data['birthdate'].substring(0, 2);
        String year = data['birthdate'].substring(6, 10);
        DateTime birthdate = DateTime.parse('$year-$month-$day');

        int age =
            (DateTime.now().difference(birthdate).inDays / 365).truncate();

        user = UserInfo(
            nickname: data['nickname'],
            photo: data['avatar'],
            preferences: preferences,
            gender: EnumToString.fromString(Gender.values, data['gender']),
            age: age,
            birthdate: birthdate,
            filters: filters,
            id: id);

        return user;
      }
      return UserInfo.empty();
    });
  }

  Future<List<String>> getSegments(String id) async {
    List<String> segments = [];

    CollectionReference segmentCollection =
        _firebaseFirestore.collection("users").doc(id).collection('segments');

    await segmentCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        segments.add(element.data()['email']);
      });
    });
    return segments;
  }

  Future<List<String>> getSegmentsDomains(String id) async {
    List<String> segments = [];
    debugPrint("userId : " + id);
    CollectionReference segmentCollection =
        _firebaseFirestore.collection("users").doc(id).collection('segments');

    await segmentCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (element.data()['validate'] == true) {
          segments.add(element.id);
        }
      });
    });
    debugPrint("segments size : " + segments.length.toString());
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

  Future<void> setTopicsToHear(List<Topic> topics, String id) async {
    CollectionReference user = _firebaseFirestore
        .collection("users")
        .doc(id)
        .collection('topics_hear');

    for (Topic topic in topics) {
      await user.doc(topic.topic).set({'time': topic.time});
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
        minimunAge: data.data()['filters']['ages'].cast<int>()[0],
        maximumAge: data.data()['filters']['ages'].cast<int>()[1],
        genders: EnumToString.fromList(
            Gender.values, data.data()['filters']['genders']),
        segments: data.data()['filters']['segments'].cast<String>(),
        badgets: data.data()['filters']['badgets'].cast<String>());
  }

  Future<List<Tuple2<UserInfo, String>>> getFilteredValidatedContacts(
      String id) async {
    List<Tuple2<String, String>> usersRoom = [];
    List<Tuple2<UserInfo, String>> contacts = [];
    Preferences filter = await getFilters(id);

    await _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) {
        usersRoom.add(Tuple2(document.id, document.data()['friend']));
      });
    });

    for (Tuple2<String, String> userRoomData in usersRoom) {
      String roomId = userRoomData.item1;
      String friendId = userRoomData.item2;

      DocumentSnapshot documentSnapshot =
          await _firebaseFirestore.collection('friends').doc(roomId).get();

      List<String> friends = documentSnapshot.data()['friends'].cast<String>();

      if (friends.contains(friendId)) {
        var userInfo = await getUser(friendId, false, false);
        var segments = await getSegments(friendId);
        var badgets = await getBadgets(friendId);

        //TODO: TEST
        /*if (userInfo.age >= filter.minimunAge &&
            userInfo.age <= filter.maximumAge &&
            _validateSegment(filter.segments, segments) &&
            _validateBadgets(filter.badgets, badgets) &&
            _validateGender(filter.genders, userInfo.gender)) {*/
        contacts.add(Tuple2(userInfo, roomId));
        //}
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

  Future<void> deleteDiscoveries(String id) async {
    CollectionReference discoveriesCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("discoveries");

    await discoveriesCollection.get().then((value) async {
      for (DocumentSnapshot documentSnapshot in value.docs) {
        await documentSnapshot.reference.delete();
      }
    });
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

  Future<List<Topic>> getTopicsHear(String id) async {
    List<Topic> topics = [];

    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_hear');

    await topicTalkCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        topics.add(Topic(element.id, element.data()['time'].toDate()));
      });
    });
    return topics;
  }

  Future<void> deleteTopicsHear(String id) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_hear');

    await topicTalkCollection.get().then((value) async {
      for (DocumentSnapshot documentSnapshot in value.docs) {
        await documentSnapshot.reference.delete();
      }
    });
  }

  Future<void> setTopicsHear(String id, List<Topic> topics) async {
    CollectionReference topicTalkCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('topics_hear');

    for (Topic topic in topics) {
      await topicTalkCollection.doc(topic.topic).set({'time': topic.time});
    }
  }

  Future<Preferences> getPreferences(String id) async {
    var user = await _firebaseFirestore.collection("users").doc(id).get();
    var data = user.data();

    return Preferences(
        minimunAge: data['preferences']['ages'].cast<int>()[0],
        maximumAge: data['preferences']['ages'].cast<int>()[1],
        genders: EnumToString.fromList(
            Gender.values, data['preferences']['genders']),
        segments: data['preferences']['segments'].cast<String>(),
        badgets: data['preferences']['badgets'].cast<String>());
  }

  Future<void> updatePreferences(String id, Preferences preferences) async {
    DocumentReference user = _firebaseFirestore.collection("users").doc(id);
    await user.update({
      'preferences': {
        'ages': [preferences.minimunAge, preferences.maximumAge],
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
        'ages': [preferences.minimunAge, preferences.maximumAge],
        'genders': FieldValue.arrayUnion(
            EnumToString.toList<Gender>(preferences.genders)),
        'segments': FieldValue.arrayUnion(preferences.segments),
        'badgets': FieldValue.arrayUnion(preferences.badgets)
      }
    });
  }

  Future<void> addFriend(String userId, String friendId, String roomId) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection('friends')
        .doc(roomId)
        .set({'friend': friendId});

    var friendDoc =
        await _firebaseFirestore.collection("friends").doc(roomId).get();

    if (!friendDoc.exists) {
      await _firebaseFirestore.collection("friends").doc(roomId).set({
        'friends': FieldValue.arrayUnion([userId])
      });
    } else {
      await _firebaseFirestore.collection("friends").doc(roomId).update({
        'friends': FieldValue.arrayUnion([userId])
      });
    }

    var doc = await _firebaseFirestore
        .collection("friends")
        .doc(roomId)
        .collection('messages')
        .doc('welcome')
        .get();

    if (!doc.exists) {
      await _firebaseFirestore
          .collection("friends")
          .doc(roomId)
          .collection('messages')
          .doc('welcome')
          .set({
        'message': 'Inicio del chat',
        'user': 'information',
        'time': DateTime.now().microsecondsSinceEpoch
      });
    }
  }

  Future<void> deleteFriend(
      String userId, String friendId, String roomId) async {
    await _firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection('friends')
        .doc(roomId)
        .delete();

    await _firebaseFirestore.collection("friends").doc(roomId).update({
      'friends': FieldValue.arrayRemove([userId])
    });
  }
}
