import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

class CurrentEditingTrackWidget extends StatelessWidget {
  final String title;
  final String noteTitle;
  final String noteText;
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
      required this.timerEnd});

  @override
  Widget build(BuildContext context) {
    String timeStart = DateFormat('hh:mm').format(timerStart);
    var infinity = String.fromCharCodes(Runes('\u221E'));
    String timeEnd =
        timerEnd == null ? infinity : DateFormat('hh:mm').format(timerEnd!);
    String timeTotal = timerEnd == null
        ? infinity
        : DateFormat(
                '${timerEnd!.difference(timerStart).inMinutes}${t.trackers.min} ${timerEnd!.difference(timerStart).inSeconds}${t.trackers.sec}')
            .format(DateTime.now());
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
        Row(
          children: [
            Expanded(
                child: DetailContainer(
              title: t.trackers.currentEditTrackStart,
              text: timeStart,
              detail: t.trackers.currentEditTrackButtonChange,
              filled: true,
            )),
            10.w,
            Expanded(
                child: DetailContainer(
              title: t.trackers.currentEditTrackFinish,
              text: timeEnd,
              detail: t.trackers.currentEditTrackButtonTimerStart,
              filled: false,
            )),
            10.w,
            Expanded(
                child: DetailContainer(
              title: t.trackers.currentEditTrackAll,
              text: timeTotal,
              detail: '',
              filled: false,
            )),
          ],
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
                icon: IconModel(iconPath: Assets.icons.icClose),
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
