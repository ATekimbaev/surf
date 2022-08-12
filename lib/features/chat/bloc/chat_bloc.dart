import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';

import '../models/chat_message_dto.dart';
import '../models/chat_message_location_dto.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    {required this.repo}
  ) : super(ChatInitialState()) {
    on<SendMessegeEvent>((event, emit) async {
      final  message = await repo.sendMessage(event.msg);
      emit(ChatSuccesState(message: message.first));
    });
    on<SendGeoMessegeEvent>((event, emit) async {
      final double lat = event.chatGeoData.location.latitude;
      final double long = event.chatGeoData.location.longitude;
      final msg = event.chatGeoData;
      emit(ChatSuccesState(message: msg, lat: lat, long: long));
    });
  }
  final ChatRepository repo; 
}
