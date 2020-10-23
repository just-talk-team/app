import 'package:equatable/equatable.dart';
import 'package:just_talk/models/contact.dart';


class MessageEvent extends Equatable {
  const MessageEvent(this.message, this.contact);
    final String message;
    final Contact contact;

  @override
  List<Object> get props => [message, contact];
}

