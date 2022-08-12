import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_send_dto.dart';

import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  TopicBloc({
    required this.repo,
  }) : super(TopicInitialState()) {
    on<TopicCreateEvent>((event, emit) async {
      await repo.createTopic(event.model);
      emit(
        TopicSucsessState(topic: event.model),
      );
    });
    on<TopicLoadingEvent>((event, emit) async {
      final topic = await repo.getTopics(
        topicsStartDate: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      );
      emit(TopicLoadedState(currentTopics: topic));
    });
  }
  final IChatTopicsRepository repo;
}
