import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Message extends Equatable {
  const Message(
      {@required this.id,
      @required this.message,
      @required this.userId,
      @required this.dateTime});

  const Message.empty()
      : id = '',
        message = '',
        userId = '',
        this.dateTime = null;

  final String id;
  final String message;
  final String userId;
  final DateTime dateTime;

  @override
  List<Object> get props => [id, message, userId, dateTime];
}
