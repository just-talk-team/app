import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class DiscoveryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoveryFound extends DiscoveryState {
  DiscoveryFound({@required String room})
      : assert(room != null),
        this.room = room;

  final String room;
  @override
  List<Object> get props => [room];
}

class DiscoveryReady extends DiscoveryState {
  DiscoveryReady({@required String room})
      : assert(room != null),
        this.room = room;

  final String room;
  @override
  List<Object> get props => [room];
}

class DiscoveryNotFound extends DiscoveryState {
  @override
  List<Object> get props => [];
}
