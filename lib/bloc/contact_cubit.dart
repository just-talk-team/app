import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/contact_state.dart';
import 'package:just_talk/models/contact.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:tuple/tuple.dart';

class ContactCubit extends Cubit<ContactsState> {
  String _userId;
  List<StreamSubscription<QuerySnapshot>> _streams;
  List<Tuple2<UserInfo, String>> _contactsInfo;
  PriorityQueue<Contact> _contacts;
  UserService _userService;

  void init() async {
    _contactsInfo = await _userService.getFilteredValidatedContacts(_userId);

    for (int i = 0; i < _contactsInfo.length; ++i) {
      Stream<QuerySnapshot> stream =
          _userService.getLastMessage(_contactsInfo[i].item2);

      _streams.add(stream.listen((query) {
        var doc = query.docs[0];

        Tuple2<UserInfo, String> userInfo = _contactsInfo
            .where((element) => element.item1 == doc.data()['userId'])
            .toList()[0];

        Contact contact = Contact(
            id: userInfo.item1.id,
            name: userInfo.item1.nickname,
            photo: userInfo.item1.photo,
            roomId: userInfo.item2,
            lastMessage: doc.data()['message'],
            lastMessageTime: doc.data()['time']);

        if (_contacts.contains(contact)) {
          _contacts.remove(contact);
        }
        _contacts.add(contact);
        emit(ContactsResult(_contacts.toList()));
      }));
    }
  }

  ContactCubit({String userId, UserService userService})
      : super(ContactsEmpty()) {
    Comparator<Contact> comparator =
        (a, b) => a.lastMessageTime.compareTo(b.lastMessageTime);
    _userId = userId;
    _userService = userService;
    _contacts = PriorityQueue(comparator);
  }

  @override
  Future<void> close() {
    _streams.forEach((element) => element.cancel());
    return super.close();
  }
}
