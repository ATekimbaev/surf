




import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';

class TopicAvatar extends StatelessWidget {
  static const double _size = 42;

  final ChatTopicDto topckData;

  const TopicAvatar({
    required this.topckData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        color: colorScheme.primary,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            topckData.name?? '',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}