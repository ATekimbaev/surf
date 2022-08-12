part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSuccesState extends ChatState {
ChatMessageDto message; 
double lat;
double long;
  ChatSuccesState({
     required this.message,
     this.lat = 0,
     this.long = 0,
  });
  
}

class ChatErrorState extends ChatState {}
