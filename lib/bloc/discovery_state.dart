import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class DiscoveryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoveryFound extends DiscoveryState {
  DiscoveryFound({@required String room})
      : assert(room != null),
        this.room = room,
        this.dateTime = DateTime.now();

  final String room;
  final DateTime dateTime;

  @override
  List<Object> get props => [room, dateTime];
}

class DiscoveryReady extends DiscoveryState {
  DiscoveryReady({@required String room})
      : assert(room != null),
        this.room = room,
        this.dateTime = DateTime.now();

  final String room;
  final DateTime dateTime;

  @override
  List<Object> get props => [room, dateTime];
}

class DiscoveryNotFound extends DiscoveryState {
  @override
  List<Object> get props => [];
}
