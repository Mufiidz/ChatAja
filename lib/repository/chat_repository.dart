import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/io.dart';

import '../data/api_services.dart';
import '../data/base_response.dart';
import '../data/base_result.dart';
import '../data/chat_response.dart';
import '../data/websocket_datasource.dart';
import '../model/message.dart';
import '../model/room_chat.dart';
import '../model/user.dart';
import '../utils/export_utils.dart';

abstract class ChatRepository {
  Future<BaseResult<ChatResponse>> getMessages(int userId);
  Future<BaseResult<void>> connectSocket(int userId);
  void connectListRoom();
  Future<void> disconnectSocket();
  Future<BaseResult<void>> sendMessage(String message);
  BaseResult<IOWebSocketChannel> getSocketChannel();
  Stream<Message?> get getSocketStream;
  Stream<List<RoomChat>?> get getSocketRoomStream;
}

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ApiServices _apiServices;
  final WebSocketDataSource _socketDataSource;

  ChatRepositoryImpl(this._apiServices, this._socketDataSource);

  @override
  Future<BaseResult<ChatResponse>> getMessages(int userId) async {
    UserMapper.ensureInitialized();
    MessageMapper.ensureInitialized();
    ChatResponseMapper.ensureInitialized();

    final BaseResult<ChatResponse> response =
        await _apiServices.getMessages(id: userId).awaitResponse;

    if (!response.isSuccess) {
      return response;
    }

    List<Message> messages = response.onDataResult.messages;

    // ignore: cascade_invocations
    messages.sort((Message a, Message b) =>
        a.createdAt?.compareTo(b.createdAt ?? DateTime.now()) ?? 0);

    messages = messages.reversed.toList();

    return DataResult<ChatResponse>(
        response.onDataResult.copyWith(messages: messages));
  }

  @override
  Future<BaseResult<void>> connectSocket(int userId) async {
    try {
      final void result = await _socketDataSource.connect(userId);
      return DataResult<void>(result);
    } catch (e) {
      return ErrorResult<void>(e.toString());
    }
  }

  @override
  Future<void> disconnectSocket() => _socketDataSource.disconnect();

  @override
  BaseResult<IOWebSocketChannel> getSocketChannel() {
    try {
      return DataResult<IOWebSocketChannel>(_socketDataSource.getChannel());
    } catch (e) {
      return ErrorResult<IOWebSocketChannel>(e.toString());
    }
  }

  @override
  Stream<Message?> get getSocketStream {
    try {
      return _socketDataSource.getChannel().stream.map((dynamic event) {
        logger.d('Chat Socket: $event');
        final MessageSocket messageSocket = MessageSocket.fromJson(event);
        logger.d(messageSocket.toJson());

        return messageSocket.message.isEmpty ? null : messageSocket.toMessage;
      });
    } catch (e) {
      return const Stream<Message>.empty();
    }
  }

  @override
  Future<BaseResult<void>> sendMessage(String message) async {
    try {
      final void result = await _socketDataSource.send(message);
      return DataResult<void>(result);
    } catch (e) {
      return ErrorResult<void>(e.toString());
    }
  }

  @override
  void connectListRoom() => _socketDataSource.connectList();

  @override
  Stream<List<RoomChat>?> get getSocketRoomStream {
    BaseResponseMapper.ensureInitialized();
    RoomChatMapper.ensureInitialized();
    try {
      return _socketDataSource.getChannel().stream.map((dynamic event) {
        logger.d('Chat Socket: $event');
        final BaseResponse<List<RoomChat>> response =
            BaseResponse<List<RoomChat>>.fromJson(event);
        final List<RoomChat>? roomChats = response.data;
        logger.d('roomChats: $roomChats');
        return roomChats?.isEmpty ?? true ? null : roomChats;
      });
    } catch (e) {
      return const Stream<List<RoomChat>>.empty();
    }
  }
}
