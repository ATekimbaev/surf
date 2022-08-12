
import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';

import 'topic_avatar.dart';

class Topics extends StatelessWidget {
  final ChatTopicDto topicData;

  const Topics({
    required this.topicData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopicAvatar(
                topckData: topicData,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          topicData.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          topicData.description ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                      ],
                      
                    ),
                     Text(
                          topicData.description ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                  ],
                ),
              ),
            ],
          ),
          onTap: (){},
        ),
      ),
    );
  }
}
