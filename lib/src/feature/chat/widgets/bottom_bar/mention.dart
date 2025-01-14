import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MentionWidget extends StatelessWidget {
  const MentionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final MessagesStore store = context.watch();

    return Observer(builder: (context) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Icon(AppIcons.arrowshapeTurnUpForwardFill,
                color: AppColors.primaryColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mentioned',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                Text(
                  store.mentionedMessage?.text ?? '',
                  // 'sfsf' * 1000,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                store.setMentionedMessage(null);
              },
              icon: const Icon(
                AppIcons.xmark,
                color: AppColors.greyLighterColor,
              ))
        ],
      );
    });
  }
}
