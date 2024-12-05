part of 'home_cubit.dart';

@MappableClass()
class HomeState extends BaseState with HomeStateMappable {
  final User user;
  final bool isLoggedOut;
  final List<RoomChat> roomChats;

  HomeState(
      {super.statusState,
      super.message,
      this.user = const User(),
      this.isLoggedOut = false,
      this.roomChats = const <RoomChat>[]})
      : super();
}
