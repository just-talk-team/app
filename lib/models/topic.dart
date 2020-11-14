import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  Topic(this.topic, this.time);

  final String topic;
  final DateTime time;

  @override
  List<Object> get props => [topic];
}
