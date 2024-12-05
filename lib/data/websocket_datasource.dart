import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../utils/export_utils.dart';

abstract class WebSocketDataSource {
  Future<void> connect(int userId);
  void connectList();
  Future<void> send(String message);
  IOWebSocketChannel getChannel();
  Future<void> disconnect();
}

@Injectable(as: WebSocketDataSource)
class WebSocketDataSourceImpl implements WebSocketDataSource {
  IOWebSocketChannel? _channel;
  final SharedPreferences _sharedPreferences;

  WebSocketDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> connect(int userId) async {
    try {
      final String token =
          _sharedPreferences.getString(Constants.cookie.toLowerCase()) ?? '';

      if (token.isEmpty) {
        throw Exception('Unauthorized');
      }
      _channel = IOWebSocketChannel.connect(
          '${Constants.socketUrl}${Endpoint.chat}?id=$userId',
          headers: <String, dynamic>{
            Constants.cookie: token,
          });
      await _channel?.ready;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> send(String message) async {
    final IOWebSocketChannel? currentChannel = _channel;
    if (currentChannel == null) {
      throw Exception('Not Connected');
    }
    try {
      await currentChannel.ready;
      currentChannel.sink.add(message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  IOWebSocketChannel getChannel() {
    final IOWebSocketChannel? currentChannel = _channel;
    if (currentChannel == null) {
      throw Exception('Not Connected');
    }
    return currentChannel;
  }

  @override
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel?.sink.close();
      _channel = null;
    }
  }

  @override
  void connectList() {
    try {
      final String token =
          _sharedPreferences.getString(Constants.cookie.toLowerCase()) ?? '';

      if (token.isEmpty) {
        throw Exception('Unauthorized');
      }

      _channel = IOWebSocketChannel.connect(
          '${Constants.socketUrl}${Endpoint.chatList}',
          headers: <String, dynamic>{
            Constants.cookie: token,
          });
    } catch (e) {
      rethrow;
    }
  }
}
