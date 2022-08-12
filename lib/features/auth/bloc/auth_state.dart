part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccesState extends AuthState {
  final TokenDto token;
  AuthSuccesState({
    required this.token,
  });
  
}

class AuthErrorState extends AuthState {}
