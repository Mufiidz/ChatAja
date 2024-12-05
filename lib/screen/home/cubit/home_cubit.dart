import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../model/room_chat.dart';
import '../../../model/user.dart';
import '../../../repository/chat_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../utils/export_utils.dart';

part 'home_state.dart';
part 'home_cubit.mapper.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  HomeCubit(this._userRepository, this._chatRepository) : super(HomeState());

  late final StreamController<List<RoomChat>> _roomChatController;
  Stream<List<RoomChat>>? get streamRoomChats => _roomChatController.stream;
  final List<RoomChat> _roomChats = <RoomChat>[];

  void initial() async {
    emit(state.copyWith(statusState: StatusState.loading));
    _roomChatController = StreamController<List<RoomChat>>.broadcast();

    _chatRepository.connectListRoom();

    final BaseResult<User> result = await _userRepository.getUser();

    final HomeState newState = result.when(
      result: (User user) =>
          state.copyWith(statusState: StatusState.success, user: user),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    _listenRooms();

    emit(newState);
  }

  Future<void> onRefresh() async {
    _roomChatController.add(<RoomChat>[]);
    // ignore: always_specify_types
    await Future.delayed(const Duration(seconds: 2),
        () => _roomChatController.sink.add(_roomChats));
  }

  void _listenRooms() {
    logger.d('listenedRooms');
    _chatRepository.getSocketRoomStream.listen((List<RoomChat>? event) {
      if (event == null || event.isEmpty) return;

      _roomChats
        ..removeWhere(
            (RoomChat roomChat) => roomChat.user.id == event.first.user.id)
        ..addAll(event)
        ..sort((RoomChat a, RoomChat b) =>
            a.message.createdAt
                ?.compareTo(b.message.createdAt ?? DateTime.now()) ??
            0);

      _roomChatController.add(_roomChats);
    });
  }

  void logOut() async {
    emit(state.copyWith(statusState: StatusState.loading));
    await _userRepository.logout();
    emit(state.copyWith(statusState: StatusState.success, isLoggedOut: true));
  }

  @override
  Future<void> close() async {
    await _chatRepository.disconnectSocket();
    return super.close();
  }
}
