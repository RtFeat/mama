import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/feature.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  const ChatItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final bool isChat = item is SingleChatItem;

    final AccountModel? participant = isChat
        ? (item as SingleChatItem).participant2
        : (item as GroupItem).participant;

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
                  ? participant?.avatarUrl
                  : (item as GroupItem).groupInfo?.avatarUrl,
              // isChat
              //     ? (item as SingleChatItem).participant2?.avatarUrl
              //     : (item as GroupItem).groupInfo?.avatarUrl,
              size: const Size(56, 56),
              radius: 28),
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
                                ? participant?.name
                                : (item as GroupItem).groupInfo?.name,
                            // isChat
                            //     ? '${(item as SingleChatItem).participant2?.name}'
                            //     : (item as GroupItem).groupInfo?.name,
                            style: textTheme.bodyMedium,
                          ),
                          if (isChat)
                            if (participant?.profession != null &&
                                participant!.profession!.isNotEmpty)
                              // if ((item as SingleChatItem)
                              //             .participant2
                              //             ?.profession !=
                              //         null &&
                              //     (item as SingleChatItem)
                              //         .participant2!
                              //         .profession!
                              //         .isNotEmpty)
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
                              if (participant?.profession != null &&
                                  participant!.profession!.isNotEmpty)
                                // if ((item as GroupItem).participant?.profession !=
                                //         null &&
                                //     (item as GroupItem)
                                //         .participant!
                                //         .profession!
                                //         .isNotEmpty)
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
                      // Image.asset(
                      //   Assets.icons.clip.path,
                      //   height: 33,
                      // ),

                      const Icon(
                        AppIcons.paperclip,
                        size: 33,
                        color: AppColors.greyBrighterColor,
                      )
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
