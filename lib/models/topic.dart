import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  Topic(this.topic, this.time);

  String topic;
  DateTime time;

  @override

  List<Object> get props => [topic, time];
}
