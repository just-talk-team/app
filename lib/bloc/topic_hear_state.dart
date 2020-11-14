import 'package:equatable/equatable.dart';
import 'package:just_talk/models/topic.dart';

class TopicHearState extends Equatable {
  @override
  List<Object> get props => [];
}

class TopicHearEmpty extends TopicHearState {
  List<Object> get props => [];
}

class TopicHearResult extends TopicHearState {
  TopicHearResult(this.topics);
  final List<Topic> topics;

  List<Object> get props => [topics];
}
