import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mama/src/data.dart';

class HelperPlayButtonWidget extends StatelessWidget {
  final String title;
  const HelperPlayButtonWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: title,
        style: textTheme.titleLarge
            ?.copyWith(color: AppColors.greyBrighterColor, fontSize: 20),
        children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(height: 20)),
          TextSpan(
            text: t.trackers.helperPlayButtonText.first,
            style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.greyBrighterColor),
          ),
          WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(width: 5)),
          WidgetSpan(
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: AppColors.purpleLighterBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  height: 12,
                  Assets.icons.icPlayer,
                  colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(width: 5)),
          TextSpan(
            text: t.trackers.helperPlayButtonText.second,
            style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.greyBrighterColor),
          )
        ],
      ),
    );
  }
}
