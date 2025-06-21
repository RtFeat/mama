import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationBadge extends StatelessWidget {
  final String title;
  const ConsultationBadge({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return SizedBox(
      height: 18,
      child: FittedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: 4.r,
            color: AppColors.purpleLighterBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              title == 'ONLINE_SCHOOL' ? t.profile.onlineSchool : title,
              maxLines: 1,
              style:
                  textTheme.labelSmall!.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
