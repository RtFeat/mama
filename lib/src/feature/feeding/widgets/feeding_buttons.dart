import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class FeedingButtons extends StatelessWidget {
  final String addBtnText;
  final Function() learnMoreTap;
  final Function() addButtonTap;
  final String? iconAsset;

  const FeedingButtons(
      {super.key,
      required this.addBtnText,
      required this.learnMoreTap,
      required this.addButtonTap,
      this.iconAsset});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomButton(
            type: CustomButtonType.outline,
            onTap: learnMoreTap,
            icon: IconModel(iconPath: Assets.icons.icLearnMore),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: textTheme.titleLarge?.copyWith(fontSize: 10),
            title: t.feeding.learnMoreBtn,
          ),
        ),
        10.w,
        Expanded(
          flex: 2,
          child: CustomButton(
            backgroundColor: AppColors.purpleLighterBackgroundColor,
            onTap: addButtonTap,
            title: addBtnText,
            icon: iconAsset == null ? null : IconModel(iconPath: iconAsset),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            textStyle: textTheme.bodyMedium
                ?.copyWith(fontSize: 15, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
