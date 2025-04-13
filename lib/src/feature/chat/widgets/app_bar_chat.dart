import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/chat/chat.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

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

    final GroupChatInfo? groupChatInfo =
        item is GroupItem ? (item as GroupItem).groupInfo : null;

    final DateTime? date = item is SingleChatItem
        ? DateTime.parse(
                (item as SingleChatItem).participant2?.lastActiveAt ?? '')
            .toLocal()
        : null;

    final DateTime now = DateTime.now();

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
                child: Text(
                  (item is SingleChatItem
                          ? (item as SingleChatItem).participant2?.name
                          : (item as GroupItem).groupInfo?.name) ??
                      '',
                  style: textTheme.bodyMedium?.copyWith(letterSpacing: .01),
                ),
              ),
              if (item is SingleChatItem)
                SizedBox(
                  height: kToolbarHeight / 2, // Ensure proper scrolling space
                  child: Text(
                    t.chat.lastSeen(
                      date: date != null &&
                              (date.year != now.year ||
                                  date.month != now.month ||
                                  date.day != now.day)
                          ? DateFormat('dd.MM.yyyy').format(date)
                          : '',
                      time: date?.formattedTime ?? '',
                    ),
                    // '${(item as SingleChatItem).participant2?.lastActiveAt} ',
                    style: textTheme.labelSmall,
                  ),
                ),
              if (item is! SingleChatItem)
                SizedBox(
                  height: kToolbarHeight / 2,
                  child: Text(
                    '${t.chat.specialists(
                      n: groupChatInfo?.numberOfSpecialists ?? 0,
                    )}, ${t.chat.participants(n: groupChatInfo?.numberOfUsers ?? 0)}, ${t.chat.inNetwork(n: groupChatInfo?.numberOfOnlineUsers ?? 0)}',
                    style: textTheme.labelSmall,
                  ),
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
                  // store.setFilters({
                  //   'query': (e) {
                  //     return true;
                  //   }
                  // });
                },
                child: const Icon(Icons.search, color: AppColors.primaryColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (item is SingleChatItem) {
                  context.pushNamed(AppViews.profileInfo, extra: {
                    'model': (item as SingleChatItem).participant2,
                  });
                } else if (groupUsersStore != null) {
                  context.pushNamed(AppViews.groupUsers, extra: {
                    'store': groupUsersStore,
                    'groupInfo': (item as GroupItem).groupInfo,
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
                        isOnGroup: item is GroupItem,
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
                // store.setFilters({
                //   'query': (e) {
                //     if (v.isEmpty) return true;

                //     return e.text?.contains(v) ?? true;
                //   }
                // });
              },
              onPressedClear: () {
                store.formGroup.control('search').value = '';
                store.setQuery('');
                // store.setFilters({
                //   'query': (e) {
                //     return true;
                //   }
                // });
              },
              formControlName: 'search',
              hintText: t.chat.hintSearchChat);
        }),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// String formatLastSeen(String isoTime) {
//   try {
//     print(isoTime);
//     DateTime dateTime = DateTime.parse(isoTime);
//     print(isoTime);

//     // Create a DateFormat object with the desired pattern and locale
//     DateFormat formatter = DateFormat('d MMMM HH:mm', 'ru');

//     // Format the date into a string
//     String formattedDate = formatter.format(dateTime);
//     return 'Был(а) в $formattedDate';
//   } catch (e) {
//     return 'Invalid time format';
//   }
// }
}
