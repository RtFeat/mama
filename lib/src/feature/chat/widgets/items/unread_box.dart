import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:skit/skit.dart';

class UnreadBox extends StatelessWidget {
  final int? unread;
  const UnreadBox({super.key, required this.unread});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final bool isSmall = (unread ?? 1) < 10;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: isSmall ? null : 100.r,
        color: AppColors.primaryColor,
        shape: isSmall ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Padding(
        padding: isSmall ? const EdgeInsets.all(8) : const EdgeInsets.all(4),
        child: Text(
          // '1',
          '$unread',
          style: textTheme.labelMedium!.copyWith(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
