import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:just_talk/models/contact.dart';

class ContactsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactsResult extends ContactsState {
  ContactsResult({@required List<Contact> contacts})
      : assert(contacts != null),
        this.contacts = contacts,
        this.date = DateTime.now();

  final List<Contact> contacts;
  final DateTime date;

  @override
  List<Object> get props => [contacts, date];
}

class ContactsEmpty extends ContactsState {
  ContactsEmpty();

  @override
  List<Object> get props => [];
}

class ContactsLoading extends ContactsState {
  ContactsLoading();

  @override
  List<Object> get props => [];
}
