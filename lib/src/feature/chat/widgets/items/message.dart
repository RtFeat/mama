import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'decoration.dart';

class MessageWidget extends StatelessWidget {
  final MessageItem item;
  const MessageWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final bool isUser = item.senderId == userStore.account.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AvatarWidget(url: item., size: size, radius: radius)
          MessageDecorationWidget(
            isUser: isUser,
            child: Text(item.text ?? ''),
          ),
        ],
      ),
    );
  }
}
