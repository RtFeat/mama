import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'avatar.dart';
import 'content.dart';
import 'reply.dart';

class MessageWidget extends StatelessWidget {
  final MessageItem item;
  final MessagesStore? store;
  final bool isAttachedMessages;
  final bool isOnGroup;
  const MessageWidget({
    super.key,
    required this.item,
    required this.store,
    this.isOnGroup = false,
    this.isAttachedMessages = false,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final bool isUser = item.senderId == userStore.account.id;

    // final GroupUsersStore? groupUsersStore = context.watch();

    // final bool isOnGroup = groupUsersStore != null;

    // final bool isOnGroup = groupUsersStore?.chatId.isNotEmpty ?? false;

    final Widget content = Content(
      item: item,
      isOnGroup: isOnGroup,
      isUser: isUser,
      store: store,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isUser
              ? const Spacer()
              : _Callback(item: item, isOnGroup: isOnGroup, isUser: isUser),
          isAttachedMessages
              ? Flexible(child: content)
              : IntrinsicWidth(
                  child: content,
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

class _Callback extends StatelessWidget {
  const _Callback({
    required this.item,
    required this.isOnGroup,
    required this.isUser,
  });

  final MessageItem item;
  final bool isOnGroup;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppViews.profileInfo, extra: {
          'model': AccountModel(
              gender: Gender.male,
              firstName: item.senderName,
              secondName: item.senderSurname,
              phone: '',
              id: item.senderId,
              profession: item.senderProfession,
              avatarUrl: item.senderAvatarUrl,
              professionId: item.professionId,
              role: switch (item.senderProfession) {
                'USER' => Role.user,
                'ADMIN' => Role.admin,
                'MODERATOR' => Role.moderator,
                'DOCTOR' => Role.doctor,
                'ONLINE_SCHOOL' => Role.onlineSchool,
                _ => Role.doctor,
              }),
          'schoolId':
              item.senderProfession == 'ONLINE_SCHOOL' ? item.senderId : null,
        });
      },
      child: MessageAvatar(
        isOnGroup: isOnGroup,
        isUser: isUser,
        avatarUrl: item.senderAvatarUrl,
      ),
    );
  }
}
