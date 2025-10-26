import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep.dart';

class CurrentEditingTrackWidget extends StatelessWidget {
  final String title;
  final String noteTitle;
  final String noteText;
  final bool isTimerStarted;
  final DateTime timerStart;
  final String formControlNameStart;
  final String formControlNameEnd;
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
      required this.isTimerStarted,
      required this.formControlNameStart,
      required this.formControlNameEnd});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    
    // Безопасное получение TimerInterface с проверкой на существование
    TimerInterface? store;
    try {
      // Проверяем, что Provider доступен
      if (context.mounted) {
        store = context.watch<TimerInterface>();
      } else {
        return const SizedBox.shrink();
      }
    } catch (e) {
      // Возвращаем заглушку если не удалось получить store
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Timer not available',
          style: textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 20),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 20),
        ),
        20.h,
        Observer(builder: (context) {
          try {
            // Проверяем, что store не null
            if (store == null) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Timer store not available',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              );
            }
            
            return EditTimeRow(
              onTap: () {},
              timerStart: store!.timerStartTime, // Используем данные из store
              timerEnd: store!.timerEndTime, // End обновляется из store
              isTimerStarted: store!.timerSleepStart, // Используем данные из store
              formControlNameStart: formControlNameStart,
              formControlNameEnd: formControlNameEnd,
              onStartTimeChanged: (v) {
                if (v != null) store!.updateStartTime(v.timeToDateTime);
              },
              onEndTimeChanged: (v) {
                if (v != null) store!.updateEndTime(v.timeToDateTime);
              },
              cryStore: store is CryStore ? store as CryStore : null,
              sleepStore: store is SleepStore ? store as SleepStore : null,
            );
          } catch (e) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Timer data not available',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            );
          }
        }),
        20.h,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomButton(
                type: CustomButtonType.outline,
                maxLines: 1,
                onTap: () {
                  onPressNote();
                },
                icon: AppIcons.pencil,
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
                icon: AppIcons.calendar,
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
