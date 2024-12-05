import 'package:dart_mappable/dart_mappable.dart';

part 'message.mapper.dart';

@MappableClass()
class Message with MessageMappable {
  final int id;
  final int roomId;
  final int sender;
  final int receiver;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Message({
    this.id = 0,
    this.roomId = 0,
    this.sender = 0,
    this.receiver = 0,
    this.message = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return MessageMapper.fromJson(json);
    if (json is String) return MessageMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}

@MappableClass()
class MessageSocket with MessageSocketMappable {
  @MappableField(key: 'senderID')
  int senderId;
  String message;
  DateTime? time;
  int id;
  int senderOne;
  int senderTwo;
  DateTime? createdAt;
  DateTime? updatedAt;

  MessageSocket({
    this.senderId = 0,
    this.message = '',
    this.time,
    this.id = 0,
    this.senderOne = 0,
    this.senderTwo = 0,
    this.createdAt,
    this.updatedAt,
  });

  Message get toMessage => Message(
        sender: senderId,
        message: message,
        createdAt: time,
      );

  factory MessageSocket.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return MessageSocketMapper.fromJson(json);
    if (json is String) return MessageSocketMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
