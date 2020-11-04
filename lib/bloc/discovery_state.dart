import 'package:equatable/equatable.dart';
import 'package:just_talk/models/room.dart';

class DiscoveryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscoveryFound extends DiscoveryState {
  DiscoveryFound();
  @override
  List<Object> get props => [];
}

class DiscoveryReady extends DiscoveryState {
  DiscoveryReady({this.room});
  final String room;
  @override
  List<Object> get props => [room];
}

class DiscoveryNotFound extends DiscoveryState {
  @override
  List<Object> get props => [];
}