import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class ReplyButton extends StatelessWidget {
  final bool isUser;
  final MessageItem message;
  final MessagesStore? store;
  const ReplyButton(
      {super.key,
      required this.isUser,
      required this.message,
      required this.store});

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
          onPressed: () {
            store?.setMentionedMessage(message);
          },
          icon: const Icon(
            AppIcons.arrowshapeTurnUpForward,
            color: AppColors.greyLighterColor,
          )),
    );
  }
}

class ReplyContent extends StatelessWidget {
  final MessageItem item;
  const ReplyContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 70,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const VerticalDivider(
                color: AppColors.primaryColor,
                thickness: 3,
                width: 4,
              ),
              4.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'sdf',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.text ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
