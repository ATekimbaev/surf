import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/widgets/topics.dart';

class TopicBody extends StatelessWidget {
  final Iterable<ChatTopicDto> topics;

  const TopicBody({
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: topics.length,
      itemBuilder: (_, index) => Topics(
        topicData: topics.elementAt(index),
      ),
    );
  }
}