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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: 100.r,
        color: AppColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Text(
          '$unread',
          style: textTheme.labelMedium!.copyWith(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
