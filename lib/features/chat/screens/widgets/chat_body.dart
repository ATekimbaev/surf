import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_messege.dart';

class ChatBody extends StatelessWidget {
  final Iterable<ChatMessageDto> messages;

  const ChatBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) => ChatMessage(
        chatData: messages.elementAt(index),
      ),
    );
  }
}
