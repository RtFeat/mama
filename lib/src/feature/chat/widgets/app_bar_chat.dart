import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/chat/chat.dart';
import 'package:marquee/marquee.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChatsAppBar extends StatelessWidget {
  final ChatItem? item;
  final MessagesStore store;
  final GroupUsersStore? groupUsersStore;

  final ScrollController scrollController;

  final double? height;

  const ChatsAppBar({
    super.key,
    this.height,
    required this.item,
    required this.store,
    required this.groupUsersStore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Observer(builder: (context) {
      return AppBar(
          backgroundColor: AppColors.lightPirple,
          surfaceTintColor: AppColors.lightPirple,
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
                  text: (item is SingleChatItem
                          ? (item as SingleChatItem).participant2?.name
                          : (item as GroupItem).groupInfo?.name) ??
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
                onTap: () {
                  store.setIsSearching(!store.isSearching);
                  store.setQuery('');
                  store.setFilters({
                    'query': (MessageItem e) {
                      return true;
                    }
                  });
                },
                child: const Icon(Icons.search, color: AppColors.primaryColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (groupUsersStore != null) {
                  context.pushNamed(AppViews.groupUsers, extra: {
                    'store': groupUsersStore,
                    'groupInfo': (item as GroupItem).groupInfo,
                  });
                } else if (item is SingleChatItem) {
                  context.pushNamed(AppViews.profileInfo, extra: {
                    'model': (item as SingleChatItem).participant2,
                  });
                }
              },
              child: AvatarWidget(
                  url: item is SingleChatItem
                      ? (item as SingleChatItem).participant2?.avatarUrl
                      : (item as GroupItem).groupInfo?.avatarUrl,
                  size: const Size(50, 50),
                  radius: 25),
            ),
            10.w,
          ],
          bottom: store.attachedMessages.isNotEmpty
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Column(
                    children: [
                      const Divider(
                        height: 3,
                        color: AppColors.lavenderBlue,
                      ),
                      PinnedMessages(
                        store: store,
                        scrollController: scrollController,
                      ),
                    ],
                  ))
              : null);
    });
  }
}

class ChatSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final MessagesStore store;
  const ChatSearchBar({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      backgroundColor: AppColors.lightPirple,
      surfaceTintColor: AppColors.lightPirple,
      leading: const SizedBox.shrink(),
      title: ReactiveForm(
        formGroup: store.formGroup,
        child: Observer(builder: (_) {
          return Finder(
              value: store.query,
              onSearchIconPressed: () => store.setIsSearching(false),
              inputBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              onChanged: (v) {
                store.setQuery(v);
                store.setFilters({
                  'query': (MessageItem e) {
                    if (v.isEmpty) return true;

                    return e.text?.contains(v) ?? true;
                  }
                });
              },
              onPressedClear: () {
                store.formGroup.control('search').value = '';
                store.setQuery('');
                store.setFilters({
                  'query': (MessageItem e) {
                    return true;
                  }
                });
              },
              formControlName: 'search',
              hintText: t.chat.hintSearchChat);
        }),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
