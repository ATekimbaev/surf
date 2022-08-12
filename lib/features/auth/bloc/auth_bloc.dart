import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';

import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    {required this.repo}
  ) : super(AuthInitialState()) {

    
    on<AuthLoginEvent>((event, emit) async {

      try {
      final token =
          await repo.signIn(login: event.userName, password: event.password);
      emit(
        AuthSuccesState(token: token),
       );
    } catch (e) {
      emit(AuthErrorState());
    }
      
    });
  }
  final IAuthRepository repo;
}
