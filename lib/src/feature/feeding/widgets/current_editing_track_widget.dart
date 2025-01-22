import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class CurrentEditingTrackWidget extends StatelessWidget {
  final String title;
  final String noteTitle;
  final String noteText;
  final bool isTimerStarted;
  final DateTime timerStart;
  final DateTime? timerEnd;
  final VoidCallback onPressNote;
  final VoidCallback onPressSubmit;
  final VoidCallback onPressCancel;
  final VoidCallback onPressManually;
  const CurrentEditingTrackWidget(
      {super.key,
      required this.title,
      required this.noteTitle,
      required this.noteText,
      required this.onPressNote,
      required this.onPressSubmit,
      required this.onPressCancel,
      required this.onPressManually,
      required this.timerStart,
      required this.timerEnd,
      required this.isTimerStarted});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 20),
        ),
        20.h,
        EditTimeRow(
          timerStart: timerStart,
          timerEnd: timerEnd,
          isTimerStarted: isTimerStarted,
        ),
        20.h,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomButton(
                type: CustomButtonType.outline,
                onTap: () {
                  onPressNote();
                },
                icon: IconModel(iconPath: Assets.icons.icPencilFilled),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                textStyle: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                title: t.trackers.currentEditTrackButtonNote,
              ),
            ),
            10.w,
            Expanded(
              flex: 2,
              child: CustomButton(
                backgroundColor: AppColors.greenLighterBackgroundColor,
                onTap: () {
                  onPressSubmit();
                },
                title: t.trackers.currentEditTrackButtonSubmit,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                textStyle: textTheme.titleMedium
                    ?.copyWith(color: AppColors.greenTextColor),
              ),
            ),
          ],
        ),
        10.h,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomButton(
                type: CustomButtonType.filled,
                backgroundColor: AppColors.redLighterBackgroundColor,
                onTap: () {
                  onPressCancel();
                },
                // icon: IconModel(iconPath: Assets.icons.icClose),
                icon: AppIcons.xmark,
                iconColor: AppColors.redColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                textStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.redColor),
                title: t.trackers.currentEditTrackButtonCancel,
              ),
            ),
            10.w,
            Expanded(
              flex: 1,
              child: CustomButton(
                backgroundColor: AppColors.purpleLighterBackgroundColor,
                onTap: () {
                  onPressManually();
                },
                title: t.trackers.currentEditTrackButtonManually,
                icon: IconModel(iconPath: Assets.icons.icCalendar),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                textStyle: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        20.h,
        Text(
          noteTitle,
          style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w400, color: AppColors.greyBrighterColor),
        ),
        5.h,
        Text(noteText,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.greyBrighterColor)),
      ],
    );
  }
}
