import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/bloc/topic_hear_state.dart';

import 'package:just_talk/models/topic.dart';
import 'package:just_talk/services/topics_service.dart';
import 'package:tuple/tuple.dart';

class TopicHearCubit extends Cubit<TopicHearState> {
  TopicsService _topicsService;
  List<StreamSubscription<List<Tuple2<Topic, bool>>>> _streams;
  List<Topic> _topics;
  bool flag;

  TopicHearCubit({TopicsService topicsService}) : super(TopicHearEmpty()) {
    _topicsService = topicsService;
    _topics = [];
    _streams = [];
    flag = true;
  }

  @override
  Future<void> close() {
    _streams.forEach((element) => element.cancel());
    return super.close();
  }

  void init(List<String> segments) {
    for (String segment in segments) {
      _streams.add(_topicsService.getTopicsToHear(segment).listen((topics) {
        topics.forEach((topic) {
          if (topic.item2) {
            int index = _topics.indexOf(topic.item1);
            if (index != -1) {
              _topics[index] = topic.item1;
            } else {
              _topics.add(topic.item1);
            }
          } else {
            _topics.remove(topic.item1);
          }
        });
        if (flag) {
          emit(TopicHearResult(List.from(_topics)));
        }
      }));
    }
  }

  void shuffle() {
    _topics.shuffle();
    flag = false;
    emit(TopicHearResult(List.from(_topics)));
  }
}
