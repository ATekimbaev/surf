part of 'topic_bloc.dart';

@immutable
abstract class TopicState {}

class TopicInitialState extends TopicState {}
class TopicLoadedState extends TopicState {
   Iterable<ChatTopicDto>  currentTopics;
  TopicLoadedState({
    required this.currentTopics,
  });
}
class TopicSucsessState extends TopicState {
  final ChatTopicSendDto topic;
  TopicSucsessState({
    required this.topic,
  });
}
class TopicErrorgState extends TopicState {}
