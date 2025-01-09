import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class PinnedMessagesView extends StatelessWidget {
  final MessagesStore? store;
  const PinnedMessagesView({super.key, required this.store});

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
      body: store != null
          ? PaginatedLoadingWidget(
              store: store!,
              isReversed: true,
              listData: () => store?.attachedMessages,
              itemBuilder: (context, item) {
                return MessageWidget(item: item);
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
