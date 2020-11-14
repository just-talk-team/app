import 'package:equatable/equatable.dart';
import 'package:just_talk/models/contact.dart';


class ContactsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactsResult extends ContactsState {
  ContactsResult(this.contacts);
  final List<Contact> contacts;

  @override
  List<Object> get props => [contacts];
}

class ContactsEmpty extends ContactsState {
  ContactsEmpty();

  @override
  List<Object> get props => [];
}
