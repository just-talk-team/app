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
    emit(ContactsLoading());
    _contactsInfo = await _userService.getFilteredValidatedContacts(_userId);

    if (_contactsInfo.length > 0) {
      for (Tuple2<UserInfo, String> contactInfo in _contactsInfo) {
        Stream<QuerySnapshot> stream =
            _userService.getLastMessage(contactInfo.item2);

        _streams.add(stream.listen((query) {
          if (query.docs.length > 0) {
            var doc = query.docs[0].data();

            Contact contact = Contact(
                id: contactInfo.item1.id,
                name: contactInfo.item1.nickname,
                photo: contactInfo.item1.photo,
                roomId: contactInfo.item2,
                lastMessage: doc['message'],
                lastMessageTime: DateTime.fromMillisecondsSinceEpoch(doc['time']));

            if (_contacts.contains(contact)) {
              _contacts.remove(contact);
            }
            _contacts.add(contact);
          }

          emit(ContactsResult(_contacts.toList()));
        }));
      }
    } else {
      emit(ContactsEmpty());
    }
  }

  ContactCubit({String userId, UserService userService})
      : super(ContactsEmpty()) {
    Comparator<Contact> comparator =
        (a, b) => a.lastMessageTime.compareTo(b.lastMessageTime);
    _userId = userId;
    _streams = [];
    _userService = userService;
    _contacts = PriorityQueue(comparator);
  }

  @override
  Future<void> close() {
    _streams.forEach((element) => element.cancel());
    return super.close();
  }
}
