import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class MessageDecorationWidget extends StatelessWidget {
  final Widget child;
  final bool isUser;
  const MessageDecorationWidget({
    super.key,
    required this.child,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubbleDecorationPaint(
        color: AppColors.whiteColor,
        isUser: isUser,
      ),
      child: Padding(
        padding:
            // all padding in body
            const EdgeInsets.all(8) +
                // padding only for decoration
                EdgeInsets.only(left: !isUser ? 10 : 0, right: isUser ? 6 : 0),
        child: child,
      ),
    );
  }
}
