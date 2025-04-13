import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/chat/state/chats.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

class ChatsBodyWidget extends StatefulWidget {
  final ChatsViewStore store;
  final String? childId;
  const ChatsBodyWidget({
    super.key,
    required this.store,
    required this.childId,
  });

  @override
  State<ChatsBodyWidget> createState() => _ChatsBodyWidgetState();
}

class _ChatsBodyWidgetState extends State<ChatsBodyWidget> {
  late final ObservableFuture future;
  // @override
  // void initState()
  //   // widget.store.loadAllGroups(
  //   //   widget.childId,
  //   // );
  //   // widget.store.loadAllChats();
  //   // future = Future.wait([
  //   //        widget.store.loadAllGroups(widget.childId),
  //   //        widget.store.loadAllChats(),
  //   //      ]);
  //   super.initState();
  // }
  //
  //
  @override
  initState() {
    // widget.store.loadAllGroups(
    //   widget.childId,
    // );
    // widget.store.loadAllChats();
    future = ObservableFuture(Future.wait([
      widget.store.loadAllGroups(widget.childId),
      widget.store.loadAllChats(),
    ]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget separator = Divider(
      indent: MediaQuery.of(context).size.width * .15,
    );

    return LoadingWidget(
        future: future,
        builder: (_) => CustomScrollView(cacheExtent: 1000, slivers: [
              _GroupsList(store: widget.store, separator: separator),
              _ChatsList(store: widget.store, separator: separator),
            ]));
  }
}

class _GroupsList extends StatelessWidget {
  final ChatsViewStore store;
  final Widget separator;
  const _GroupsList({
    required this.store,
    required this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CardWidget(
          title: t.chat.groupChatsListTitle,
          child: CustomScrollView(
              shrinkWrap: true,
              cacheExtent: 1000,
              semanticChildCount: store.groups.listData.length,
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                PaginatedLoadingWidget(
                  isFewLists: true,
                  store: store.groups,
                  separator: (_, __) => separator,
                  itemBuilder: (context, item, _) {
                    return ChatItemWidget(item: item);
                  },
                ),
              ])),
    );
  }
}

class _ChatsList extends StatefulWidget {
  final ChatsViewStore store;
  final Widget separator;
  const _ChatsList({
    required this.store,
    required this.separator,
  });

  @override
  State<_ChatsList> createState() => __ChatsListState();
}

class __ChatsListState extends State<_ChatsList> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CardWidget(
        titleWidget: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomToggleButton(
            initialIndex: widget.store.chats.chatUserTypeFilter.index,
            items: [
              t.chat.buttonToogleAll,
              t.chat.buttonToogleSpecialist,
            ],
            onTap: (index) {
              widget.store.chats
                  .setChatUserTypeFilter(ChatUserTypeFilter.values[index]);
            },
            btnWidth: MediaQuery.of(context).size.width / 2.35,
            btnHeight: 38,
          ),
        ),
        child: CustomScrollView(
            shrinkWrap: true,
            cacheExtent: 1000,
            physics: const NeverScrollableScrollPhysics(),
            semanticChildCount: widget.store.chats.filteredChats.length,
            slivers: [
              PaginatedLoadingWidget(
                isFewLists: true,
                separator: (_, __) => widget.separator,
                store: widget.store.chats,
                listData: () => widget.store.chats.filteredChats,
                itemBuilder: (context, item, _) {
                  return ChatItemWidget(item: item);
                },
              ),
            ]),
      ),
    );
  }
}
