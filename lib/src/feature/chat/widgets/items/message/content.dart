import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'assets.dart';
import 'decoration.dart';
import 'header.dart';
import 'reply.dart';
import 'text.dart';

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
    return MessageDecorationWidget(
      isUser: isUser,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!item.hasVoice) Header(item: item, isOnGroup: isOnGroup),
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
                  child: MessageText(item: item),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
