import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class LearnMoreWidget extends StatelessWidget {
  final VoidCallback onPressClose;
  final VoidCallback onPressButton;
  final String title;

  const LearnMoreWidget({
    super.key,
    required this.onPressClose,
    required this.onPressButton,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.lightBlue),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => onPressClose(),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.greyColor,
                ),
              ),
            ),
            AutoSizeText(
              '$title:',
              style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyBrighterColor),
            ),
            20.h,
            CustomButton(
              isSmall: false,
              type: CustomButtonType.outline,
              onTap: () => onPressButton(),
              icon: IconModel(iconPath: Assets.icons.icLearnMore),
              title: t.trackers.learnMoreBtn,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: textTheme.titleLarge?.copyWith(fontSize: 10),
            ),
            16.h
          ],
        ),
      ),
    );
  }
}
