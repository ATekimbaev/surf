import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/bloc/chat_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/topic_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/chat/repository/chat_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}


final globalKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InitWidget(
      child: MaterialApp(
        scaffoldMessengerKey: globalKey,
        home: AuthScreen(
          authRepository: AuthRepository(StudyJamClient()),
        ),
      ),
    );
  }
}

class InitWidget extends StatelessWidget {
  const InitWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AuthRepository(
              StudyJamClient(),
            ),
          ),
          RepositoryProvider(
            create: (context) => ChatRepository(
              StudyJamClient(),
            ),
          ),
          RepositoryProvider(
            create: (context) => ChatTopicsRepository(
              StudyJamClient(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: ((context) => AuthBloc(
                    repo: RepositoryProvider.of<AuthRepository>(context),
                  )),
            ),
            BlocProvider<ChatBloc>(
              create: ((context) => ChatBloc(
                    repo: RepositoryProvider.of<ChatRepository>(context),
                  )),
            ),
            BlocProvider<TopicBloc>(
              create: ((context) => TopicBloc(
                    repo: RepositoryProvider.of<ChatTopicsRepository>(context),
                  )),
            ),
          ],
          child: child,
        ));
  }
}