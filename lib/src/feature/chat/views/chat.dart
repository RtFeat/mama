import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:marquee/marquee.dart';
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

    // if (widget.groupUsersStore != null) {
    //   widget.groupUsersStore?.loadPage(queryParams: {});
    // }

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
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightPirple,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.iconColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight / 2,
              child: Marquee(
                text: (widget.item is SingleChatItem
                        ? (widget.item as SingleChatItem).participant2?.name
                        : (widget.item as GroupItem).groupInfo?.name) ??
                    '',
                velocity: 30,
                blankSpace: 10,
                style: textTheme.bodyMedium?.copyWith(letterSpacing: .01),
              ),
            ),
            Text(
              'sdfdsf',
              style: textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.search, color: AppColors.primaryColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.groupUsersStore != null) {
                context.pushNamed(AppViews.groupUsers, extra: {
                  'store': widget.groupUsersStore,
                  'groupInfo': (widget.item as GroupItem).groupInfo,
                });
              } else if (widget.item is SingleChatItem) {
                context.pushNamed(AppViews.profileInfo, extra: {
                  'model': (widget.item as SingleChatItem).participant2,
                });
              }
            },
            child: AvatarWidget(
                url: widget.item is SingleChatItem
                    ? (widget.item as SingleChatItem).participant2?.avatarUrl
                    : (widget.item as GroupItem).groupInfo?.avatarUrl,
                size: const Size(50, 50),
                radius: 25),
          ),
          10.w,
        ],
      ),

      // CustomAppBar(
      //   leading: GestureDetector(
      //     onTap: () {
      //       context.pop();
      //     },
      //     child: const Icon(
      //       Icons.arrow_back_ios,
      //       color: AppColors.iconColor,
      //     ),
      //   ),
      //   titleWidget: Column(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       Text((widget.item is SingleChatItem
      //               ? (widget.item as SingleChatItem).participant2?.name
      //               : (widget.item as GroupItem).groupInfo?.name) ??
      //           ''),
      //     ],
      //   ),
      //   action: GestureDetector(
      //     onTap: () {
      //       if (widget.groupUsersStore != null) {
      //         context.pushNamed(AppViews.groupUsers, extra: {
      //           'store': widget.groupUsersStore,
      //           'groupInfo': (widget.item as GroupItem).groupInfo,
      //         });
      //       }
      //     },
      //     child: AvatarWidget(
      //         url: widget.item is SingleChatItem
      //             ? (widget.item as SingleChatItem).participant2?.avatarUrl
      //             : (widget.item as GroupItem).groupInfo?.avatarUrl,
      //         size: const Size(40, 40),
      //         radius: 20),
      //   ),
      // ),
      body: PaginatedLoadingWidget(
        store: widget.store,
        itemBuilder: (context, item) {
          return MessageWidget(item: item);
        },
      ),
    );
  }
}
