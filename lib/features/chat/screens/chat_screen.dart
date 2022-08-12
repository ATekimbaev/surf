import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_body.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/widgets/chat_text_field.dart';


import 'widgets/chat_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    required this.chatRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _nameEditingController = TextEditingController();

  Iterable<ChatMessageDto> _currentMessages = [];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider<ChatBloc>.value(
      value: BlocProvider.of<ChatBloc>(context),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ChatAppBar(
            controller: _nameEditingController,
            onUpdatePressed: _onUpdatePressed,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ChatBody(
                messages: _currentMessages,
              ),
            ),
            BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccesState) {
                  _onSendPressed(state.message.message ?? '');
                }
              },
              builder: (context, state) {
                return ChatTextField(onSendPressed: _onSendPressed);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUpdatePressed() async {
    final messages = await widget.chatRepository.getMessages();
    setState(() {
      _currentMessages = messages;
    });
  }

  Future<void> _onSendPressed(String messageText) async {
    final messages = await widget.chatRepository.sendMessage(messageText);
    setState(() {
      _currentMessages = messages;
    });
  }

  Future<void> _onSendGeoPressed(ChatGeolocationDto location) async {
    final geoMassege =
        await widget.chatRepository.sendGeolocationMessage(location: location);
    setState(() {
      _currentMessages = geoMassege;
    });
  }
}
