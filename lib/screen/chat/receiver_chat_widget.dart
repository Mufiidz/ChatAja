import 'package:flutter/material.dart';

import '../../model/message.dart';
import '../../utils/datetime_ext.dart';

class ReceiverChatWidget extends StatelessWidget {
  final Message message;
  final String receiver;
  const ReceiverChatWidget(
      {required this.message, required this.receiver, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(receiver.substring(0, 2)),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message.message),
                Text(message.createdAt?.formatTime ?? '-')
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
