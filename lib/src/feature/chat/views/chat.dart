import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:skit/skit.dart';

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
        Provider(create: (_) {
          return GroupUsersStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              chatId: (item is GroupItem)
                  ? (item as GroupItem).groupChatId ?? ''
                  : '');
        }),
        Provider(create: (_) {
          return GroupSpecialistsStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              chatId: (item is GroupItem)
                  ? (item as GroupItem).groupChatId ?? ''
                  : '');
        }),
      ],
      builder: (context, child) {
        final GroupUsersStore? groupUsersStore = context.watch();
        final GroupSpecialistsStore? specialistsStore = context.watch();

        return _Body(
          socket: context.watch(),
          item: item,
          groupUsersStore: groupUsersStore,
          specialistsStore: specialistsStore,
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  final ChatItem? item;
  final GroupUsersStore? groupUsersStore;
  final GroupSpecialistsStore? specialistsStore;
  final ChatSocketFactory socket;

  const _Body({
    required this.socket,
    required this.item,
    this.groupUsersStore,
    this.specialistsStore,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = context.read<MessagesStore>();
    store.init();

    logger.info('${widget.item.runtimeType}');

    store.setChatId(widget.item is SingleChatItem
        ? widget.item?.id
        : (widget.item as GroupItem).groupChatId);

    logger.info('${widget.item?.id}');

    store.setChatType(widget.item is SingleChatItem ? 'solo' : 'group');

    store.loadPage(
      fetchFunction: (filters, apiClient, path) {
        return apiClient.get(
            '$path/${widget.item is SingleChatItem ? 'solo' : 'group'}',
            queryParams: {'limit': '10', 'chat_id': store.chatId, ...filters});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MessagesStore>();
    final bool isGroup = widget.item is GroupItem;

    return Observer(builder: (context) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        },
        child: Scaffold(
            backgroundColor: AppColors.purpleLighterBackgroundColor,
            appBar: store.isSearching
                ? ChatSearchBar(store: store) as PreferredSizeWidget
                : PreferredSize(
                    preferredSize: Size.fromHeight(
                        store.attachedMessages.isNotEmpty
                            ? kToolbarHeight * 2
                            : kToolbarHeight),
                    child: ChatsAppBar(
                        item: widget.item,
                        scrollController: store.scrollController!,
                        store: store,
                        specialistsStore: widget.specialistsStore,
                        groupUsersStore: widget.groupUsersStore),
                  ),
            bottomNavigationBar: ChatBottomBar(
              store: context.watch(),
            ),
            body: Observer(builder: (_) {
              return Stack(
                children: [
                  PaginatedLoadingWidget(
                    scrollController: store.scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    store: store,
                    isReversed: true,
                    emptyData: const SizedBox.shrink(),
                    separator: (index, item) => DateSeparatorInChat(
                        index: index,
                        item: item,
                        store: store,
                        scrollController: store.scrollController!),
                    listData: () =>
                        store.isSearching ? store.filteredList : store.messages,
                    itemBuilder: (context, item, _) {
                      final index = store.messages.indexOf(item);
                      // _messageKeys[index] = GlobalKey();

                      // Для первого элемента добавляем дату в начало
                      if (index == store.messages.length - 1) {
                        final firstDate = (item).createdAt?.toLocal();

                        if (firstDate == null) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatDateWidget(
                              scrollController: store.scrollController!,
                              date: firstDate,
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                            ),
                            AutoScrollTag(
                              index: index,
                              controller: store.scrollController!,
                              key: ValueKey(item.id),
                              child: MessageWidget(
                                // key: _messageKeys[index],
                                item: item,
                                store: store,
                                isOnGroup: isGroup,
                              ),
                            ),
                          ],
                        );
                      }
                      return AutoScrollTag(
                          index: index,
                          controller: store.scrollController!,
                          key: ValueKey(item.id),
                          child: MessageWidget(
                            isOnGroup: isGroup,
                            // key: _messageKeys[index],
                            item: item,
                            store: store,
                          ));
                    },
                  ),
                  if (store.currentShowingMessage != null)
                    ChatDateWidget(
                        scrollController: store.scrollController!,
                        date:
                            store.currentShowingMessage!.createdAt!.toLocal()),
                ],
              );
            })),
      );
    });
  }
}
