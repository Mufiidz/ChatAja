import 'package:flutter/material.dart';

import '../../model/message.dart';
import '../../utils/datetime_ext.dart';
import '../../utils/export_utils.dart';

class SenderChatWidget extends StatelessWidget {
  final Message message;
  const SenderChatWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const SizedBox(
          width: 24,
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(message.message),
                Text(
                  message.createdAt?.formatTime ?? '-',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: CircleAvatar(
            backgroundColor: context.colorScheme.secondaryContainer,
            child: const Text('Me'),
          ),
        )
      ],
    );
  }
}
