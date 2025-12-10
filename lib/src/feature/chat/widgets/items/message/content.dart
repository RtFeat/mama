import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'assets.dart';
import 'decoration.dart';
import 'header.dart';
import 'reply.dart';
import 'text.dart';

class MenuShower {
  MenuShower._();
  static void show(
      BuildContext context, List<MenuItem> items, Offset tapPosition) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
        context: context,
        color: AppColors.whiteColor,
        constraints: const BoxConstraints(
          minWidth: 100,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        position: RelativeRect.fromRect(
            tapPosition & const Size(40, 40), Offset.zero & overlay.size),
        items: items
            .map((e) => PopupMenuItem(
                value: e,
                onTap: e.onSelected,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(e.icon, color: e.color),
                    ),
                    Text(
                      e.label,
                      style: e.textStyle ??
                          textTheme.titleSmall?.copyWith(color: e.color),
                    ),
                  ],
                )))
            .toList());
  }
}

class MenuItem {
  final String label;
  final IconData icon;
  final TextStyle? textStyle;
  final Color color;
  final Function() onSelected;
  MenuItem(
      {required this.label,
      required this.icon,
      required this.onSelected,
      this.textStyle,
      this.color = AppColors.blackColor});
}

class Content extends StatelessWidget {
  final bool isUser;
  final bool isOnGroup;
  final MessageItem item;
  final MessagesStore? store;
  const Content(
      {super.key,
      required this.store,
      required this.item,
      required this.isOnGroup,
      required this.isUser});

  @override
  Widget build(BuildContext context) {
    Offset pos = Offset.zero;
    void storePosition(TapDownDetails details) {
      pos = details.globalPosition;
    }

    final UserStore userStore = context.watch<UserStore>();
    final ChatSocketFactory socket = context.watch<ChatSocketFactory>();
    final bool isAdmin =
        userStore.role == Role.admin || userStore.role == Role.moderator;

    return Observer(builder: (context) {
      final entries = [
        MenuItem(
          label: t.chat.reply,
          icon: AppIcons.arrowshapeTurnUpForward,
          onSelected: () {
            store?.setMentionedMessage(item);
          },
        ),
        if (isAdmin || kDebugMode)
          MenuItem(
            label: item.isAttached ? t.chat.unpin : t.chat.pin,
            icon: item.isAttached ? AppIcons.pinSlash : AppIcons.pin,
            onSelected: () {
              item.setIsAttached(!item.isAttached);
              store?.resetSelectedPinnedMessage(!item.isAttached);
              socket.socket.pinMessage(item.id!, item.isAttached);
            },
          ),
        if (isAdmin || kDebugMode)
          MenuItem(
            label: t.chat.delete,
            icon: AppIcons.xmark,
            color: AppColors.redColor,
            onSelected: () => socket.socket.deleteMessage(item.id!),
          ),
      ];

      return GestureDetector(
        onTapDown: storePosition,
        onSecondaryTapDown: storePosition,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // Unfocus keyboard
          MenuShower.show(context, entries, pos);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: MessageDecorationWidget(
            isUser: isUser,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!item.hasVoice)
                    Header(
                      item: item,
                      isOnGroup: isOnGroup,
                      isUser: isUser,
                    ),
                  if (item.reply != null &&
                      (item.reply?.id != null && item.reply!.id!.isNotEmpty))
                    ReplyContent(
                      item: item.reply!,
                    ),
                  MessageAssets(item: item),
                  if (item.text != null && item.text!.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: MessageText(
                            item: item,
                            store: store,
                          ),
                        ),
                      ],
                    ),
                ]),
          ),
        ),
      );
    });
  }
}
