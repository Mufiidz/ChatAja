import 'package:flutter/material.dart';

import '../../model/room_chat.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../chat/chat_screen.dart';

class ItemRoomChat extends StatelessWidget {
  final RoomChat roomChat;
  final User currentUser;
  const ItemRoomChat(
      {required this.roomChat, required this.currentUser, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppRoute.to(ChatScreen(user: roomChat.user)),
      child: Container(
        width: context.mediaSize.width,
        padding: const EdgeInsets.all(16),
        child: Row(children: <Widget>[
          CircleAvatar(
            child: Text(roomChat.user.username?.substring(0, 2) ?? '-'),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_username(roomChat.user.username ?? '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    _message(roomChat.message.message),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ]),
          )),
          Text(
            roomChat.message.createdAt?.toRelativeTime() ?? '-',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          )
        ]),
      ),
    );
  }

  String _message(String message) =>
      roomChat.message.sender == currentUser.id ? 'You: $message' : message;

  String _username(String username) =>
      username == currentUser.username ? '$username (Me)' : username;
}
