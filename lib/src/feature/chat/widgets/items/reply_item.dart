import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/chat/chat.dart';

class ReplyItemWidget extends StatelessWidget {
  final ReplyItem replyItem;
  final VoidCallback? onTapClose;
  const ReplyItemWidget({super.key, required this.replyItem, this.onTapClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.lightPirple),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              // child: Image.asset(
              //   Assets.icons.replyFilled.path,
              //   height: 28,
              // ),
              child: Icon(
                AppIcons.arrowshapeTurnUpForwardFill,
                size: 28,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Reply(replyItem: replyItem),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                onTapClose!();
              },
              // icon: Image.asset(
              //   Assets.icons.close.path,
              //   height: 28,
              // ),

              icon: const Icon(
                AppIcons.xmark,
                color: AppColors.greyLighterColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
