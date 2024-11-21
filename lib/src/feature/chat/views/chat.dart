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
    return Provider(
        create: (context) => MessagesStore(
            restClient: context.read<Dependencies>().restClient,
            chatType: item is SingleChatItem ? 'solo' : 'group'),
        builder: (context, child) {
          final MessagesStore store = context.watch();

          return Scaffold(
            body: _Body(
              store: store,
              item: item,
            ),
          );
        });
  }
}

class _Body extends StatefulWidget {
  final MessagesStore store;
  final ChatItem? item;

  const _Body({
    required this.store,
    required this.item,
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
      appBar: const CustomAppBar(),
      body: PaginatedLoadingWidget(
        store: widget.store,
        itemBuilder: (context, item) {
          return Text(item.text ?? '');
        },
      ),
    );
  }
}
