import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class CardWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final double? elevation;
  const CardWidget({
    super.key,
    this.title,
    this.titleWidget,
    required this.child,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shadowColor: AppColors.skyBlue,
        elevation: elevation ?? 1,
        color: AppColors.whiteColor,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
          child: Column(
            children: [
              if (title != null)
                Text(
                  title!,
                  style: textTheme.labelSmall!.copyWith(fontSize: 14),
                ),
              if (titleWidget != null) titleWidget!,
              child,
            ],
          ),
        ),
      ),
    );
  }
}
