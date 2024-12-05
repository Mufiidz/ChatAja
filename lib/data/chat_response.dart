import 'package:dart_mappable/dart_mappable.dart';

import '../model/message.dart';
import '../model/user.dart';

part 'chat_response.mapper.dart';

@MappableClass()
class ChatResponse with ChatResponseMappable {
  final User user;
  final List<Message> messages;

  ChatResponse({this.user = const User(), this.messages = const <Message>[]});

  factory ChatResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return ChatResponseMapper.fromJson(json);
    if (json is String) return ChatResponseMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
