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
        final MessagesStore store = context.watch();
        final GroupUsersStore? groupUsersStore = context.watch();
        final GroupSpecialistsStore? specialistsStore = context.watch();

        return _Body(
          socket: context.watch(),
          store: store,
          item: item,
          groupUsersStore: groupUsersStore,
          specialistsStore: specialistsStore,
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  final MessagesStore store;
  final ChatItem? item;
  final GroupUsersStore? groupUsersStore;
  final GroupSpecialistsStore? specialistsStore;
  final ChatSocket socket;

  const _Body({
    required this.socket,
    required this.store,
    required this.item,
    this.groupUsersStore,
    this.specialistsStore,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  // final Map<int, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    widget.store.init();

    logger.info('${widget.item.runtimeType}');

    widget.store.setChatId(widget.item is SingleChatItem
        ? widget.item?.id
        : (widget.item as GroupItem).groupChatId);

    logger.info('${widget.item?.id}');

    widget.store.setChatType(widget.item is SingleChatItem ? 'solo' : 'group');

    widget.store.loadPage(
      fetchFunction: (filters, apiClient, path) {
        return apiClient.get(
            '$path/${widget.item is SingleChatItem ? 'solo' : 'group'}',
            queryParams: {
              'limit': '10',
              'chat_id': widget.store.chatId,
              ...filters
            });
      },
    );

    widget.socket.markMessagesAsRead();

    // widget.store.scrollController?.addListener(_updateCurrentDate);

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // _messageKeys.clear();
    // widget.store.scrollController?.removeListener(_updateCurrentDate);
    if (context.mounted) {
      widget.store.dispose();
    }
  }

  // void _updateCurrentDate() {
  //   if (widget.store.messages.isEmpty) return;

  //   // Проходим по сообщениям с конца списка (так как reversed)
  //   for (int i = widget.store.messages.length - 1; i >= 0; i--) {
  //     final key = _messageKeys[i];
  //     if (key == null) continue;

  //     final context = key.currentContext;
  //     if (context != null) {
  //       final box = context.findRenderObject() as RenderBox?;
  //       if (box != null) {
  //         final double position = box.localToGlobal(Offset.zero).dy;

  //         // Проверяем видимость сообщения (находится в нижней части экрана)
  //         if (position >= 0 && position <= MediaQuery.of(context).size.height) {
  //           widget.store.setCurrentShowingMessage(widget.store.messages[i]);
  //           return; // Как только нашли, выходим из метода
  //         }
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
            appBar: widget.store.isSearching
                ? ChatSearchBar(store: widget.store) as PreferredSizeWidget
                : PreferredSize(
                    preferredSize: Size.fromHeight(
                        widget.store.attachedMessages.isNotEmpty
                            ? kToolbarHeight * 2
                            : kToolbarHeight),
                    child: ChatsAppBar(
                        item: widget.item,
                        scrollController: widget.store.scrollController!,
                        store: widget.store,
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
                    scrollController: widget.store.scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    store: widget.store,
                    isReversed: true,
                    emptyData: const SizedBox.shrink(),
                    separator: (index, item) => DateSeparatorInChat(
                        index: index,
                        item: item,
                        store: widget.store,
                        scrollController: widget.store.scrollController!),
                    listData: () => widget.store.isSearching
                        ? widget.store.filteredList
                        : widget.store.messages,
                    itemBuilder: (context, item, _) {
                      final index = widget.store.messages.indexOf(item);
                      // _messageKeys[index] = GlobalKey();

                      // Для первого элемента добавляем дату в начало
                      if (index == widget.store.messages.length - 1) {
                        final firstDate = (item).createdAt?.toLocal();

                        if (firstDate == null) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatDateWidget(
                              scrollController: widget.store.scrollController!,
                              date: firstDate,
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                            ),
                            AutoScrollTag(
                              index: index,
                              controller: widget.store.scrollController!,
                              key: ValueKey(item.id),
                              child: MessageWidget(
                                // key: _messageKeys[index],
                                item: item,
                                store: widget.store,
                                isOnGroup: isGroup,
                              ),
                            ),
                          ],
                        );
                      }
                      return AutoScrollTag(
                          index: index,
                          controller: widget.store.scrollController!,
                          key: ValueKey(item.id),
                          child: MessageWidget(
                            isOnGroup: isGroup,
                            // key: _messageKeys[index],
                            item: item,
                            store: widget.store,
                          ));
                    },
                  ),
                  if (widget.store.currentShowingMessage != null)
                    ChatDateWidget(
                        scrollController: widget.store.scrollController!,
                        date: widget.store.currentShowingMessage!.createdAt!
                            .toLocal()),
                ],
              );
            })),
      );
    });
  }
}
