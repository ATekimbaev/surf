part of 'topic_bloc.dart';

@immutable
abstract class TopicEvent {}

class TopicCreateEvent extends TopicEvent {
  final String name;
  final String description;
  
  late final model = ChatTopicSendDto(name: name, description: description);
  
  TopicCreateEvent({
    required this.name,
    required this.description,
   
  });
  

} 

class TopicLoadingEvent extends TopicEvent {
 
}
