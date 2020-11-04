import 'package:equatable/equatable.dart';

class Room extends Equatable {
  Room({this.room, this.userId, this.partnerId, this.ready});

  final String room;
  final String userId;
  final String partnerId;
  final bool ready;

  @override
  List<Object> get props => [room, userId, partnerId, ready];
}
