part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class SendMessegeEvent extends ChatEvent {
  final String msg;

 SendMessegeEvent({
    required this.msg,
  });
}

class SendImageEvent extends ChatEvent {}

class SendGeoMessegeEvent extends ChatEvent {
  final ChatMessageGeolocationDto chatGeoData; 
  SendGeoMessegeEvent({
    required this.chatGeoData,
  });

}
