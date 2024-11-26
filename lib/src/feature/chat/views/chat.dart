import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  final ChatItem? item;
  const ChatView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (context) => MessagesStore(
                restClient: context.read<Dependencies>().restClient,
                chatType: item is SingleChatItem ? 'solo' : 'group'),
          ),
          if (item is GroupItem)
            Provider(
                create: (_) => GroupUsersStore(
                    restClient: context.read<Dependencies>().restClient,
                    chatId: (item as GroupItem).groupChatId!)),
        ],
        builder: (context, child) {
          final MessagesStore store = context.watch();
          final GroupUsersStore? groupUsersStore = context.watch();

          return Scaffold(
            body: _Body(
              store: store,
              item: item,
              groupUsersStore: groupUsersStore,
            ),
          );
        });
  }
}

class _Body extends StatefulWidget {
  final MessagesStore store;
  final ChatItem? item;
  final GroupUsersStore? groupUsersStore;

  const _Body({
    required this.store,
    required this.item,
    this.groupUsersStore,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    logger.info('${widget.item.runtimeType}');

    logger.info('${widget.item?.id}');

    // logger.info('${(widget.item as GroupItem).groupChatId}');

    if (widget.groupUsersStore != null) {
      widget.groupUsersStore?.loadPage(queryParams: {});
    }

    widget.store.loadPage(queryParams: {
      'limit': '10',
      'chat_id': widget.item is SingleChatItem
          ? widget.item?.id
          : (widget.item as GroupItem).groupChatId
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPirple,
      appBar: const CustomAppBar(),
      body: PaginatedLoadingWidget(
        store: widget.store,
        itemBuilder: (context, item) {
          return MessageWidget(item: item);
        },
      ),
    );
  }
}
