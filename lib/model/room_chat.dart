import 'package:dart_mappable/dart_mappable.dart';

import 'message.dart';
import 'user.dart';

part 'room_chat.mapper.dart';

@MappableClass()
class RoomChat with RoomChatMappable {
  @MappableField(key: 'users')
  User user;

  @MappableField(key: 'messages')
  Message message;

  RoomChat({
    this.user = const User(),
    this.message = const Message(),
  });

  factory RoomChat.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return RoomChatMapper.fromJson(json);
    if (json is String) return RoomChatMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }

}
