import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class SpecialistDaySlot extends StatelessWidget {
  final WorkSlot slot;
  final List<CalendarEventData<Object?>> event;
  const SpecialistDaySlot({super.key, required this.slot, required this.event});

  String formatTimeRange(DateTime startTime, DateTime endTime) {
    // Форматируем время с ведущими нулями
    String formatTime(DateTime time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    // Возвращаем отформатированную строку
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          slot.workSlot,
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.greyBrighterColor,
          ),
        ),
        MeetingsSection(
            whichSection: 1,
            showDecoration: false,
            meetingsList: event
                .where((i) =>
                    i.startTime?.hour == int.parse(slot.workSlot.split(':')[0]))
                .map((e) {
              final bool isLater = e.startTime!.hour > now.hour;

              return MeetingBox(
                  startedAt: e.startTime ?? DateTime.now(),
                  icon: IconModel(
                    iconPath: !isLater
                        ? Assets.icons.icCheckmark
                        : Assets.icons.icClock,
                    size: isLater ? const Size(18, 18) : const Size(12, 12),
                    color: !isLater
                        ? AppColors.greenTextColor
                        : AppColors.primaryColor,
                  ),
                  timeStyle: textTheme.labelLarge?.copyWith(
                    color: !isLater
                        ? AppColors.greenTextColor
                        : AppColors.primaryColor,
                  ),
                  tutorNameStyle: textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      color: !isLater
                          ? AppColors.greenTextColor
                          : AppColors.primaryColor),
                  backgroundColor: !isLater
                      ? AppColors.greenLighterBackgroundColor
                      : AppColors.purpleLighterBackgroundColor,
                  scheduledTime: formatTimeRange(e.startTime!, e.endTime!),
                  meetingType: '',
                  isCancelled: false,
                  tutorFullName: '${e.event}',
                  whichSection: 1,
                  consultationId: '');
            }).toList()),
      ],
    );
  }
}
