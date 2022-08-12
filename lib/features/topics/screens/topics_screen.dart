import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topic_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/widgets/bg_widget.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import '../../auth/models/token_dto.dart';
import '../../chat/repository/chat_repository.dart';
import 'create_topic_screen.dart';
import 'widgets/topic_body.dart';

/// Screen with different chat topics to go to.
class TopicsScreen extends StatefulWidget {
  /// Constructor for [TopicsScreen].
  const TopicsScreen({Key? key, required this.chatTopickRepository})
      : super(key: key);
  final ChatTopicsRepository chatTopickRepository;

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  Iterable<ChatTopicDto> _currentTopics = [];
  late SharedPreferences _prefs;
  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicBloc>.value(
      value: BlocProvider.of<TopicBloc>(context)..add(TopicLoadingEvent()),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _pushToChat(context, _prefs.getString('token') ?? '');
                },
                icon: Icon(Icons.chat_outlined)),
            IconButton(
              onPressed: _onUpdatePressed,
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<TopicBloc, TopicState>(
                builder: (context, state) {
                  if (state is TopicLoadedState) {
                    return TopicBody(
                      topics: state.currentTopics,
                    );
                  }
                  return TopicBody(
                    topics: _currentTopics,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          _pushToCreateTopic(context, _prefs.getString('token') ?? '' );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _onUpdatePressed() async {
    final topics = await widget.chatTopickRepository.getTopics(
      topicsStartDate: DateTime.now().subtract(
        const Duration(days: 1),
      ),
    );
    setState(() {
      _currentTopics = topics;
    });
  }

  void _pushToChat(BuildContext context, String token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token),
            ),
          );
        },
      ),
    );
  }
  void _pushToCreateTopic(BuildContext context, String token) {
    Navigator.push<CreateTopicScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return CreateTopicScreen(
            chatTopickRepository: ChatTopicsRepository(
              StudyJamClient().getAuthorizedClient(token),
            ),
          );
        },
      ),
    );
  }
}
