import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/models/contact.dart';

class Message extends Equatable {
  const Message(
      {@required this.id, @required this.message, @required this.contact, @required this.dateTime});

  const Message.test(DateTime dateTime)
      : id = '0',
        message = 'Hola',
        contact = const Contact.test(),
        this.dateTime = dateTime;

  final String id;
  final String message;
  final Contact contact;
  final DateTime dateTime;

  static const empty = Message(id: null, message: null, contact: null, dateTime: null);

  @override
  List<Object> get props => [id, message, contact, dateTime];
}
