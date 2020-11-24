import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Contact extends Equatable {
  const Contact(
      {@required this.id,
      @required this.name,
      @required this.photo,
      @required this.roomId,
      @required this.lastMessage,
      @required this.lastMessageTime});

  final String id;
  final String name;
  final String photo;
  final String roomId;
  final String lastMessage;
  final DateTime lastMessageTime;

  @override
  List<Object> get props => [id, lastMessage, lastMessageTime];
}
