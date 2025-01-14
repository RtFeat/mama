import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
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

          return _Body(
            store: store,
            item: item,
            groupUsersStore: groupUsersStore,
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
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    logger.info('${widget.item.runtimeType}');

    logger.info('${widget.item?.id}');

    // logger.info('${(widget.item as GroupItem).groupChatId}');

    // if (widget.groupUsersStore != null) {
    //   widget.groupUsersStore?.loadPage(queryParams: {});
    // }

    widget.store.loadPage(queryParams: {
      'limit': '10',
      'chat_id': widget.item is SingleChatItem
          ? widget.item?.id
          : (widget.item as GroupItem).groupChatId
    });

    _scrollController.addListener(_updateCurrentDate);

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _scrollController.removeListener(_updateCurrentDate);
    _scrollController.dispose();
  }

  void _updateCurrentDate() {
    if (widget.store.messages.isEmpty) return;

    // Проходим по сообщениям с конца списка (так как reversed)
    for (int i = widget.store.messages.length - 1; i >= 0; i--) {
      final key = _messageKeys[i];
      if (key == null) continue;

      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final double position = box.localToGlobal(Offset.zero).dy;

          // Проверяем видимость сообщения (находится в нижней части экрана)
          if (position >= 0 && position <= MediaQuery.of(context).size.height) {
            widget.store.setCurrentShowingMessage(widget.store.messages[i]);
            return; // Как только нашли, выходим из метода
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
          backgroundColor: AppColors.purpleLighterBackgroundColor,
          appBar: widget.store.isSearching
              ? ChatSearchBar(store: widget.store)
              : ChatsAppBar(
                      item: widget.item,
                      store: widget.store,
                      groupUsersStore: widget.groupUsersStore)
                  as PreferredSizeWidget,
          bottomNavigationBar: const ChatBottomBar(),
          body: Observer(builder: (_) {
            return Stack(
              children: [
                PaginatedLoadingWidget(
                  scrollController: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  store: widget.store,
                  isReversed: true,
                  separator: (index, item) {
                    final previousItem =
                        index > 0 ? widget.store.messages[index - 1] : null;
                    final currentDate = (item).createdAt?.toLocal();
                    final previousDate = previousItem != null
                        ? (previousItem).createdAt?.toLocal()
                        : null;

                    // Если это первый элемент или дата отличается, показать дату
                    if (previousDate == null ||
                        currentDate?.day != previousDate.day) {
                      return _Date(
                          store: widget.store,
                          scrollController: _scrollController,
                          date: currentDate!);
                    }
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  listData: () => widget.store.isSearching
                      ? widget.store.filteredMessages
                      : widget.store.messages,
                  itemBuilder: (context, item) {
                    final index = widget.store.messages.indexOf(item);
                    _messageKeys[index] = GlobalKey();

                    // Для первого элемента добавляем дату в начало
                    if (index == widget.store.messages.length - 1) {
                      final firstDate = (item).createdAt?.toLocal();

                      if (firstDate == null) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Date(
                            store: widget.store,
                            scrollController: _scrollController,
                            date: firstDate,
                            padding: const EdgeInsets.only(
                              bottom: 10,
                            ),
                          ),
                          // Text(
                          //   DateFormat('dd MMMM yyyy').format(firstDate),
                          //   style: const TextStyle(color: Colors.grey),
                          // ),
                          MessageWidget(key: _messageKeys[index], item: item),
                        ],
                      );
                    }
                    return MessageWidget(key: _messageKeys[index], item: item);
                  },
                ),
                if (widget.store.currentShowingMessage != null)
                  _Date(
                      store: widget.store,
                      scrollController: _scrollController,
                      date: widget.store.currentShowingMessage!.createdAt!
                          .toLocal())
              ],
            );
          }));
    });
  }
}

class _Date extends StatelessWidget {
  final DateTime date;
  final EdgeInsets? padding;
  final MessagesStore store;
  final ScrollController scrollController;
  const _Date(
      {required this.date,
      this.padding,
      required this.store,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final DateTime now = DateTime.now();
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final bool isTomorrow = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1;

    final String dateToText = isToday
        ? t.home.today
        : isTomorrow
            ? t.home.tomorrow
            : DateFormat(
                'dd MMMM yyyy',
                TranslationProvider.of(context).flutterLocale.languageCode,
              ).format(date);

    return Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 10,
            ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dateToText,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          )
        ]));
  }
}
