import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'avatar.dart';
import 'content.dart';
import 'reply.dart';

class MessageWidget extends StatelessWidget {
  final MessageItem item;
  final MessagesStore? store;
  const MessageWidget({
    super.key,
    required this.item,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final bool isUser = item.senderId == userStore.account.id;

    final GroupUsersStore? groupUsersStore = context.watch();

    final bool isOnGroup = groupUsersStore?.chatId.isNotEmpty ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          MessageAvatar(
            isOnGroup: isOnGroup,
            isUser: isUser,
            avatarUrl: item.senderAvatarUrl,
          ),
          IntrinsicWidth(
            child: Content(
              item: item,
              isOnGroup: isOnGroup,
              isUser: isUser,
              store: store,
            ),
          ),
          ReplyButton(
            isUser: isUser,
            message: item,
            store: store,
          ),
        ],
      ),
    );
  }
}
