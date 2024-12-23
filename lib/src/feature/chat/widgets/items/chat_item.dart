import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/feature.dart';

// class ChatItemSingle extends StatelessWidget {
//   final ChatModelSingle chat;
//   const ChatItemSingle({super.key, required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     return ChatItemWidget(
//       chatEntity: ChatEntity.singleChat,
//       chatItem: ChatItemModel(
//         avatarUrl: chat.participant1.avatarUrl,
//         name: '${chat.participant1.firstName} ${chat.participant1.secondName} ',
//         isAttach: chat.lastMessage?.filePath != null &&
//             chat.lastMessage!.filePath!.isNotEmpty,
//         profession: chat.participant1.profession,
//         unreadMessages: chat.participant1Unread,
//         lastMessageName: chat.lastMessage?.nickname,
//         lastMessageText: chat.lastMessage?.text,
//       ),
//     );
//   }
// }

// class ChatItemGroup extends StatelessWidget {
//   final ChatModelGroup chat;
//   const ChatItemGroup({super.key, required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     return ChatItemWidget(
//       chatEntity: ChatEntity.groupChat,
//       chatItem: ChatItemModel(
//         avatarUrl: chat.groupChatInfo.avatar ?? '',
//         name: chat.groupChatInfo.name ?? '',
//         isAttach: chat.lastMessage != null &&
//             chat.lastMessage?.filePath != null &&
//             chat.lastMessage!.filePath!.isNotEmpty,
//         profession:
//             chat.participant.profession!, //sender last message profession
//         unreadMessages: chat.unreadMessages,
//         lastMessageName: chat.lastMessage?.nickname,
//         lastMessageText: chat.lastMessage?.text,
//       ),
//     );
//   }
// }

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  // final ChatItemModel chatItem;
  // final ChatEntity chatEntity;
  const ChatItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final bool isChat = item is SingleChatItem;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.pushNamed(AppViews.chatView, extra: {
          'item': item,
        });
      },
      child: Row(
        children: [
          AvatarWidget(
              url: isChat
                  ? (item as SingleChatItem).participant1?.avatarUrl
                  : (item as GroupItem).groupInfo?.avatarUrl,
              size: const Size(56, 56),
              radius: 28),
          // Flexible(
          //   flex: 1,
          //   child: chatItem.avatarUrl != null
          //       ? CircleAvatar(
          //           radius: 28,
          //           backgroundImage: NetworkImage(
          //             chatItem.avatarUrl!,
          //           ))
          //       : const SizedBox(
          //           height: 56,
          //           width: 56,
          //           child: DecoratedBox(
          //             decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: AppColors.purpleLighterBackgroundColor,
          //             ),
          //           ),
          //         ),
          // ),
          8.w,
          Flexible(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isChat
                                ? '${(item as SingleChatItem).participant1?.firstName} ${(item as SingleChatItem).participant1?.secondName}'
                                : (item as GroupItem).groupInfo?.name,
                            style: textTheme.bodyMedium,
                          ),
                          if (isChat)
                            if ((item as SingleChatItem)
                                        .participant1
                                        ?.profession !=
                                    null &&
                                (item as SingleChatItem)
                                    .participant1!
                                    .profession!
                                    .isNotEmpty)
                              // if (chatEntity == ChatEntity.singleChat)
                              //   if (chatItem.profession != null &&
                              //       chatItem.profession!.isNotEmpty)
                              WidgetSpan(
                                child: ProfessionBox(
                                  profession: (item as SingleChatItem)
                                      .participant1!
                                      .profession!,
                                ),
                              ),
                        ],
                      ),
                    ),
                    if (item.unreadMessages != null && item.unreadMessages! > 0)
                      UnreadBox(
                        unread: item.unreadMessages,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: RichText(
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.lastMessage?.nickname?.trim(),
                              style: textTheme.labelMedium,
                            ),
                            if (!isChat)
                              if ((item as GroupItem).participant?.profession !=
                                      null &&
                                  (item as GroupItem)
                                      .participant!
                                      .profession!
                                      .isNotEmpty)
                                // if (chatEntity == ChatEntity.groupChat)
                                //   if (chatItem.profession != null &&
                                //       chatItem.profession!.isNotEmpty)
                                WidgetSpan(
                                  child: ProfessionBox(
                                    profession: (item as GroupItem)
                                        .participant!
                                        .profession!,
                                  ),
                                ),
                            TextSpan(
                              text: ': ',
                              style: textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: item.lastMessage?.text,
                              style: textTheme.labelMedium!
                                  .copyWith(color: AppColors.greyBrighterColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (item.lastMessage != null &&
                        item.lastMessage?.filePath != null &&
                        item.lastMessage!.filePath!.isNotEmpty)
                      Image.asset(
                        Assets.icons.clip.path,
                        height: 33,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
