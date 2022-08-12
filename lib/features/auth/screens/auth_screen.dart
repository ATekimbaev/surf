import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/topics_screen.dart';
import 'package:surf_practice_chat_flutter/features/widgets/custom_button.dart';
import 'package:surf_practice_chat_flutter/features/widgets/custom_text_field.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import '../../widgets/bg_widget.dart';

class AuthScreen extends StatefulWidget {
  final IAuthRepository authRepository;
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final globalKey = GlobalKey<ScaffoldMessengerState>();
  late SharedPreferences _prefs;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String userName = 'ATekimbaev';
  String password = 'exLNzUFkzA41';

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
    return BlocProvider<AuthBloc>.value(
      value: BlocProvider.of<AuthBloc>(context),
      child: Scaffold(
        body: BgWidget(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomTextField(
                controller: loginController,
                text: 'Log In',
                isPasswordType: false,
                icon: Icons.account_circle,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: passwordController,
                text: 'Password',
                isPasswordType: true,
                icon: Icons.key_outlined,
              ),
              const SizedBox(
                height: 15,
              ),
              Builder(
                builder: (context) => BlocConsumer<AuthBloc, AuthState>(
                  listener: (_, state) {
                    if (state is AuthSuccesState) {
                      _prefs.setString('token', state.token.token);
                      String token = _prefs.getString('token') ?? '';

                      _pushToChat(context, token);
                    }
                    if (state is AuthErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(''),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button(
                      title: 'Вход',
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthLoginEvent(
                              userName: userName, password: password),
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _pushToChat(BuildContext context,  token) {
    Navigator.push<TopicsScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return TopicsScreen(
            chatTopickRepository: ChatTopicsRepository(
              StudyJamClient().getAuthorizedClient(token),
            ),
          );
        },
      ),
    );
  }
}
