import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topic_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/widgets/bg_widget.dart';
import 'package:surf_practice_chat_flutter/features/widgets/custom_button.dart';
import 'package:surf_practice_chat_flutter/features/widgets/custom_text_field.dart';


import '../models/chat_topic_send_dto.dart';

/// Screen, that is used for creating new chat topics.
class CreateTopicScreen extends StatefulWidget {
  /// Constructor for [CreateTopicScreen].
  const CreateTopicScreen({
    Key? key,
    required this.chatTopickRepository,
  }) : super(key: key);
  final ChatTopicsRepository chatTopickRepository;

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить чат'),
      ),
      body: BgWidget(
        child: BlocProvider<TopicBloc>.value(
          value: BlocProvider.of<TopicBloc>(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                    text: 'Название',
                    icon: Icons.pending_actions,
                    isPasswordType: false,
                    controller: nameController),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                    text: 'Описание',
                    icon: Icons.pending_actions,
                    isPasswordType: false,
                    controller: descriptionController),
                const SizedBox(
                  height: 25,
                ),
                Builder(builder: (context) {
                  return BlocListener<TopicBloc, TopicState>(
                    listener: (context, state) {
                      if (state is TopicSucsessState) {
                        _onUpdatePressed(state.topic.name ?? '',
                            state.topic.description ?? '');
                        Navigator.pop(context);
                      }
                    },
                    child: Button(
                        title: 'Создать',
                        onTap: () {
                          BlocProvider.of<TopicBloc>(context).add(
                            TopicCreateEvent(
                                name: nameController.text,
                                description: descriptionController.text),
                          );
                        }),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onUpdatePressed(String name, String description) async {
    widget.chatTopickRepository.createTopic(
      ChatTopicSendDto(name: name, description: description),
    );
  }
}
