import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class PinnedMessagesView extends StatelessWidget {
  final MessagesStore? store;
  final ScrollController? scrollController;
  const PinnedMessagesView(
      {super.key, required this.store, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: AppColors.purpleLighterBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 30,
        title: Text(
          t.chat.pinnedMessages,
          style: textTheme.bodyMedium,
        ),
      ),
      bottomNavigationBar: ChatBottomBar(
        store: store!,
      ),
      body: store != null
          ? PaginatedLoadingWidget(
              store: store!,
              isReversed: true,
              padding: const EdgeInsets.symmetric(vertical: 16),
              listData: () => store?.attachedMessages,
              separator: (index, item) => DateSeparatorInChat(
                  index: index,
                  item: item,
                  isAttachedMessages: true,
                  store: store!,
                  scrollController: scrollController!),
              itemBuilder: (context, item, _) {
                return MessageWidget(
                  item: item,
                  store: store,
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
