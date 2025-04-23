import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class PinnedMessages extends StatelessWidget {
  final MessagesStore store;
  final ScrollController scrollController;
  final bool isOnGroup;
  const PinnedMessages(
      {super.key,
      required this.store,
      required this.isOnGroup,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    // final MessageItem? pinnedMessage = store.pinnedMessage;

    return Observer(builder: (_) {
      if (store.attachedMessages.isNotEmpty) {
        return Material(
            color: AppColors.lightPirple,
            child: ListTile(
                onTap: () {
                  store.nextPinnedMessage();
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
                subtitle: _Title(store: store),
                leading: SizedBox(
                  width: 20,
                  child: store.attachedMessages.length <= 3
                      ? Column(
                          children: store.attachedMessages.mapIndexed((i, e) {
                            final bool isSelected =
                                i == store.selectedPinnedMessageIndex;

                            return Expanded(
                              child: VerticalDivider(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.greyLighterColor,
                                  width: 20,
                                  thickness: 2,
                                  indent: 2,
                                  endIndent: 2),
                            );
                          }).toList(),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: store.attachedMessages.length,
                          itemBuilder: (context, index) {
                            final bool isSelected =
                                index == store.selectedPinnedMessageIndex;

                            return SizedBox(
                              height: 10,
                              child: VerticalDivider(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.greyLighterColor,
                                  width: 20,
                                  thickness: 2,
                                  indent: 2,
                                  endIndent: 2),
                            );
                          },
                        ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed(AppViews.pinnedMessagesView, extra: {
                        'store': store,
                        'scrollController': scrollController,
                        'isOnGroup': isOnGroup,
                      });
                    },
                    icon: const Icon(
                      AppIcons.pinFill,
                      color: AppColors.greyLighterColor,
                    ),
                  ),
                )));
      }
      return const SizedBox.shrink();
    });
  }
}

class _Title extends StatelessWidget {
  final MessagesStore store;
  const _Title({
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Observer(
      builder: (context) {
        final MessageItem? pinnedMessage = store.pinnedMessage;
        final String? asset =
            switch (pinnedMessage?.files?.firstOrNull?.typeFile) {
          'jpg' || 'jpeg' || 'png' => t.chat.photo,
          'm4a' => t.chat.voice,
          _ => null,
        };
        return Text(
          asset ?? pinnedMessage?.text ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }
}
