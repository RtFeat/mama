import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'decoration.dart';
import 'header.dart';
import 'reply.dart';

class Content extends StatelessWidget {
  final bool isUser;
  final bool isOnGroup;
  final MessageItem item;
  const Content(
      {super.key,
      required this.item,
      required this.isOnGroup,
      required this.isUser});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final MessagesStore store = context.watch();

    return MessageDecorationWidget(
      isUser: isUser,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Header(item: item, isOnGroup: isOnGroup),
          if (item.reply != null &&
              (item.reply?.id != null && item.reply!.id!.isNotEmpty))
            ReplyContent(
              item: item.reply!,
            ),
          Row(
            children: [
              Expanded(
                child: SubstringHighlight(
                  text: item.text ?? '',
                  textStyle: textTheme.titleSmall!.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  term: store.query ?? '',
                  textStyleHighlight: textTheme.titleSmall!.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    backgroundColor: AppColors.purpleBrighterBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
