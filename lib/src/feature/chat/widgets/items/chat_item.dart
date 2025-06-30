import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  const ChatItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final ChatsViewStore store = context.watch();
    final isChat = item is SingleChatItem;
    final participant = isChat
        ? (item as SingleChatItem).participant2
        : (item as GroupItem).participant;

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          item.setUnreadMessages(0);
          store.setSelectedChat(item);
          context.pushNamed(AppViews.chatView, extra: {'item': item});
        },
        child: Row(
          children: [
            _AvatarPart(
              avatarUrl: isChat
                  ? participant?.avatarUrl
                  : (item as GroupItem).groupInfo?.avatarUrl,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Observer(builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleRow(
                      item: item,
                      isChat: isChat,
                      participant: participant,
                    ),
                    if (item.lastMessage != null)
                      _MessagePreview(
                        item: item,
                        isChat: isChat,
                        participant: participant,
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _AvatarPart extends StatelessWidget {
  final String? avatarUrl;

  const _AvatarPart({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      url: avatarUrl,
      size: const Size(56, 56),
      radius: 28,
    );
  }
}

class _TitleRow extends StatelessWidget {
  final ChatItem item;
  final bool isChat;
  final AccountModel? participant;

  const _TitleRow({
    required this.item,
    required this.isChat,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Observer(builder: (_) {
      return Row(
        children: [
          Expanded(
            child: Text(
              isChat
                  ? participant?.name ?? ''
                  : (item as GroupItem).groupInfo?.name ?? '',
              style: textTheme.bodyMedium?.copyWith(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isChat && participant?.profession?.isNotEmpty == true)
            ConsultationBadge(title: participant!.profession!),
          if (item.unreadMessages != null && item.unreadMessages! > 0)
            UnreadBox(unread: item.unreadMessages),
        ],
      );
    });
  }
}

class _MessagePreview extends StatelessWidget {
  final ChatItem item;
  final bool isChat;
  final AccountModel? participant;

  const _MessagePreview({
    required this.item,
    required this.isChat,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final MessageItem? lastMessage = item.lastMessage;

    return Observer(builder: (_) {
      return Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  // if (item.lastMessage?.nickname?.trim().isNotEmpty == true)
                  TextSpan(
                    text:
                        '${lastMessage?.senderFullName?.trim() ?? lastMessage?.nickname?.trim()}: ',
                    style: textTheme.labelMedium,
                  ),
                  TextSpan(
                    text: lastMessage?.text ?? '',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.greyBrighterColor,
                    ),
                  ),
                  if (!isChat && participant?.profession?.isNotEmpty == true)
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ConsultationBadge(
                          title: participant!.profession!,
                          // compact: true,
                        ),
                      ),
                    ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (lastMessage?.filePath?.isNotEmpty == true)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                AppIcons.paperclip,
                size: 22,
                color: AppColors.greyBrighterColor,
              ),
            ),
        ],
      );
    });
  }
}
