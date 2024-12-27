import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'decoration.dart';

class MessageWidget extends StatelessWidget {
  final MessageItem item;
  const MessageWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final UserStore userStore = context.watch<UserStore>();
    final bool isUser = item.senderId == userStore.account.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isUser
              ? const AvatarWidget(url: null, size: Size(40, 40), radius: 20)
              : const Spacer(),
          Expanded(
            flex: 5,
            child: MessageDecorationWidget(
              isUser: isUser,
              child: Text(
                item.text ?? '',
                style: textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    AppIcons.arrowshapeTurnUpForward,
                    color: AppColors.greyLighterColor,
                  )),
            ),
        ],
      ),
    );
  }
}
