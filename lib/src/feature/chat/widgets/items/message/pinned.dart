import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class PinnedMessages extends StatelessWidget {
  final MessagesStore store;
  const PinnedMessages({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Observer(builder: (_) {
      if (store.attachedMessages.isNotEmpty) {
        return Material(
            color: AppColors.lightPirple,
            child: ListTile(
                onTap: () {
                  context.pushNamed(AppViews.pinnedMessagesView, extra: {
                    'store': store,
                  });
                },
                dense: true,
                minLeadingWidth: 1,
                horizontalTitleGap: 4,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                style: ListTileStyle.drawer,
                title: Text(
                  t.chat.pinned,
                  style: textTheme.labelLarge,
                ),
                subtitle: Text(
                  store.attachedMessages[0].text ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                leading: Column(
                  children: store.attachedMessages.mapIndexed((index, message) {
                    if (store.attachedMessages.length <= 3) {
                      return const Expanded(
                        child: VerticalDivider(
                            width: 20, thickness: 2, indent: 2, endIndent: 2),
                      );
                    }

                    return const SizedBox.shrink();
                  }).toList(),
                ),

                // onTap: pinnedMessageStore.nextPinnedMessage,
                trailing:
                    // Padding(
                    //     padding: const EdgeInsets.only(
                    //         right: AppConstants.kDefaultPadding),
                    //     child:
                    // IconButton(
                    //     onPressed: () {
                    // if (store.attachedMessages.length == 1) {
                    // final message =
                    //     pinnedMessageStore.selectedPinnedMessage;
                    // message.togglePinned();
                    // store.updateMessage(message);
                    // } else {
                    // context.goNamed(AppViews.pinnedMessages,
                    //     pathParameters: {
                    //       'itemId': homeViewStore.selectedItem!.id!
                    //     });
                    // }
                    // },
                    // splashRadius: 20,
                    // icon:
                    // Observer(builder: (context) {
                    //   return store.attachedMessages.length == 1
                    //       ? const Icon(
                    //           Icons.close,
                    //           color: AppColors.greyLighterColor,
                    //         )
                    //       :
                    const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    AppIcons.pinFill,
                    color: AppColors.greyLighterColor,
                    // );
                    // }
                  ),
                ))
            // )
            // ),
            );
      }
      return const SizedBox.shrink();
    });
  }
}
