part of 'chat_cubit.dart';

@MappableClass()
class ChatState extends BaseState with ChatStateMappable {
  final List<Message> messages;
  final User user;
  ChatState(
      {super.message,
      super.statusState,
      this.messages = const <Message>[],
      this.user = const User()});
}
