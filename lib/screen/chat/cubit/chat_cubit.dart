import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../data/chat_response.dart';
import '../../../model/message.dart';
import '../../../model/user.dart';
import '../../../repository/chat_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../utils/export_utils.dart';

part 'chat_state.dart';
part 'chat_cubit.mapper.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  ChatCubit(this._chatRepository, this._userRepository) : super(ChatState());

  late final StreamController<List<Message>> _messageController;
  Stream<List<Message>> get streamMessages =>
      _messageController.stream; // Stream<List<Message>>
  final List<Message> _messages = <Message>[];

  void initial(int userId) async {
    emit(state.copyWith(statusState: StatusState.loading));
    _messageController = StreamController<List<Message>>.broadcast();
    // Connect Socket
    final BaseResult<void> result = await _chatRepository.connectSocket(userId);
    // Get Current User
    final BaseResult<User> resultUser = await _userRepository.getUser();

    // if socket error
    if (!result.isSuccess) {
      emit(state.copyWith(
        statusState: StatusState.failure,
        message: 'Error connect socket',
      ));
    }

    final ChatState newState = resultUser.when(
      result: (User user) => state.copyWith(user: user, messages: _messages),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    emit(newState);

    getMessages(userId);
  }

  void getMessages(int userRoomId) async {
    emit(state.copyWith(statusState: StatusState.loading));
    _messages.clear();
    _messageController.add(<Message>[]);

    final BaseResult<ChatResponse> result =
        await _chatRepository.getMessages(userRoomId);

    final ChatState newState = result.when(
      result: (ChatResponse chatResponse) {
        _messages.addAll(chatResponse.messages);
        _messageController.add(_messages);
        return state.copyWith(
            statusState: StatusState.idle, messages: chatResponse.messages);
      },
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }

  void sendMessage(String message) async {
    logger.d('sendMessage: $message');
    await _chatRepository.sendMessage(message);
    _chatRepository.getSocketStream.listen((Message? event) {
      if (event == null) return;
      _messages.add(event);
      logger.d('Messages: $_messages');
      _messages.sort((Message a, Message b) =>
          a.createdAt?.compareTo(b.createdAt ?? DateTime.now()) ?? 0);
      _messageController.add(_messages.reversed.toList());
    });
  }

  void disconnect() async {
    emit(state.copyWith(statusState: StatusState.loading));
    await _chatRepository.disconnectSocket();
    await _messageController.close();
    emit(state.copyWith(statusState: StatusState.success));
  }
}
