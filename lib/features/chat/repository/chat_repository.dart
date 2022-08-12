import 'package:surf_practice_chat_flutter/features/chat/exceptions/invalid_message_exception.dart';
import 'package:surf_practice_chat_flutter/features/chat/exceptions/user_not_found_exception.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

abstract class IChatRepository {
  static const int maxMessageLength = 80;
  Future<Iterable<ChatMessageDto>> getMessages();

  Future<Iterable<ChatMessageDto>> sendMessage(String message);

  Future<Iterable<ChatMessageDto>> sendGeolocationMessage({
    required ChatGeolocationDto location,
    String? message,
  });

  Future<ChatUserDto> getUser(int userId);
}

class ChatRepository implements IChatRepository {
  final StudyJamClient _studyJamClient;

  ChatRepository(this._studyJamClient);

  @override
  Future<Iterable<ChatMessageDto>> getMessages() async {
    final messages = await _fetchAllMessages();

    return messages;
  }

  @override
  Future<Iterable<ChatMessageDto>> sendMessage(String message) async {
    if (message.length > IChatRepository.maxMessageLength) {
      throw InvalidMessageException('Message "$message" is too large.');
    }
    await _studyJamClient.sendMessage(SjMessageSendsDto(text: message));

    final messages = await _fetchAllMessages();

    return messages;
  }

  @override
  Future<Iterable<ChatMessageDto>> sendGeolocationMessage({
    required ChatGeolocationDto location,
    String? message,
  }) async {
    if (message != null && message.length > IChatRepository.maxMessageLength) {
      throw InvalidMessageException('Message "$message" is too large.');
    }
    await _studyJamClient.sendMessage(SjMessageSendsDto(
      text: message,
      geopoint: location.toGeopoint(),
    ));

    final messages = await _fetchAllMessages();

    return messages;
  }

  @override
  Future<ChatUserDto> getUser(int userId) async {
    final user = await _studyJamClient.getUser(userId);
    if (user == null) {
      throw UserNotFoundException('User with id $userId had not been found.');
    }
    final localUser = await _studyJamClient.getUser();
    return localUser?.id == user.id
        ? ChatUserLocalDto.fromSJClient(user)
        : ChatUserDto.fromSJClient(user);
  }

  Future<Iterable<ChatMessageDto>> _fetchAllMessages() async {
    final messages = <SjMessageDto>[];

    var isLimitBroken = false;
    var lastMessageId = 0;

    while (!isLimitBroken) {
      final batch = await _studyJamClient.getMessages(
          lastMessageId: lastMessageId, limit: 10000);
      messages.addAll(batch);
      lastMessageId = batch.last.chatId;
      if (batch.length < 10000) {
        isLimitBroken = true;
      }
    }

    final messagesWithUsers = <int, int>{};
    for (final message in messages) {
      messagesWithUsers[message.id] = message.userId;
    }
    final users = await _studyJamClient
        .getUsers(messagesWithUsers.values.toSet().toList());
    final localUser = await _studyJamClient.getUser();

    return messages
        .map(
          (sjMessageDto) => sjMessageDto.geopoint == null
              ? ChatMessageDto.fromSJClient(
                  sjMessageDto: sjMessageDto,
                  sjUserDto: users.firstWhere(
                      (userDto) => userDto.id == sjMessageDto.userId),
                  isUserLocal: users
                          .firstWhere(
                              (userDto) => userDto.id == sjMessageDto.userId)
                          .id ==
                      localUser?.id,
                )
              : ChatMessageGeolocationDto.fromSJClient(
                  sjMessageDto: sjMessageDto,
                  sjUserDto: users.firstWhere(
                      (userDto) => userDto.id == sjMessageDto.userId),
                ),
        )
        .toList();
  }
}
