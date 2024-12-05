import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../di/injection.dart';
import '../../model/message.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/list_widget.dart';
import 'cubit/chat_cubit.dart';
import 'receiver_chat_widget.dart';
import 'sender_chat_widget.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  const ChatScreen({required this.user, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScrollController _scrollController = ScrollController();
  late final ChatCubit _chatCubit;
  late final User userRoom;
  late final int userRoomId;

  @override
  void initState() {
    userRoom = widget.user;
    logger.d('userRoom: $userRoom');
    final int? userRoomId = widget.user.id;
    _chatCubit = getIt<ChatCubit>();
    if (userRoomId != null && userRoomId > 0) {
      this.userRoomId = userRoomId;
      _chatCubit.initial(userRoomId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppbarWidget(userRoom.username ?? '-'),
      body: BlocConsumer<ChatCubit, ChatState>(
        bloc: _chatCubit,
        listener: (BuildContext context, ChatState state) {
          logger.d('ChatState: $state');
        },
        builder: (BuildContext context, ChatState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => context.focusScope.unfocus(),
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async => _chatCubit.getMessages(userRoomId),
                    child: StreamBuilder<List<Message>>(
                        stream: _chatCubit.streamMessages,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Message>> snapshot) {
                          logger.d('Messages Stream: ${snapshot.data}');
                          if (snapshot.data?.isEmpty ??
                              state.messages.isEmpty) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                  width: context.mediaSize.width,
                                  height:
                                      context.mediaSize.height - kToolbarHeight,
                                  alignment: Alignment.center,
                                  child: const Text('No messages')),
                            );
                          }
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListWidget<Message>(
                              snapshot.data ?? state.messages,
                              scrollController: _scrollController,
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              isSeparated: true,
                              reverse: true,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              itemBuilder: (BuildContext context,
                                  Message message, int index) {
                                if (message.sender == state.user.id) {
                                  return SenderChatWidget(
                                    message: message,
                                  );
                                } else {
                                  return ReceiverChatWidget(
                                    message: message,
                                    receiver: userRoom.username ?? '-',
                                  );
                                }
                              },
                              separatorBuilder: (BuildContext context,
                                      Message item, int index) =>
                                  const SizedBox(
                                height: 8,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: context.mediaSize.width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                      Expanded(
                        child: FormBuilder(
                          key: _formKey,
                          child: FormBuilderTextField(
                            name: 'message',
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send)),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _sendMessage() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    final String? message = formKeyState.value['message'];
    if (message == null) {
      return;
    }
    logger.d('writing a message : $message');
    _chatCubit.sendMessage(message);
    formKeyState.reset();
    final double maxScroll = _scrollController.position.maxScrollExtent;
    logger
      ..d('maxScroll: $maxScroll')
      ..d('scrollController: ${_scrollController.hasClients}');

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _chatCubit.disconnect();
    super.dispose();
  }
}
