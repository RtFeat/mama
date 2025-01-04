import 'package:calendar_view/calendar_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class SpecialistDaySlot extends StatelessWidget {
  final WorkSlot slot;
  final List<CalendarEventData<Object?>> event;
  const SpecialistDaySlot({super.key, required this.slot, required this.event});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          slot.startTime.timeRange(slot.endTime),
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.greyBrighterColor,
          ),
        ),
        MeetingsSection(
            whichSection: 1,
            showDecoration: false,
            meetingsList: event.where((i) {
              // List<String> split = slot.workSlot.split('-');
              // List<String> startSplit = split[0].split(':');
              // List<String> endSplit = split[1].split(':');

              final startSlotHour = slot.startTime.hour;
              final startSlotMinute = slot.startTime.minute;
              final endSlotHour = slot.endTime.hour;
              final endSlotMinute = slot.endTime.minute;

              final start = (i.startTime?.hour ?? 0) > startSlotHour ||
                  ((i.startTime?.hour ?? 0) == startSlotHour &&
                      (i.startTime?.minute ?? 0) >= startSlotMinute);

              final end = (i.endTime?.hour ?? 0) < endSlotHour ||
                  ((i.endTime?.hour ?? 0) == endSlotHour &&
                      (i.endTime?.minute ?? 0) <= endSlotMinute);

              return start && end;
            }).mapIndexed((i, e) {
              final bool isLater = e.startTime!.hour > now.hour;

              return MeetingBox(
                  index: i,
                  startedAt: e.startTime ?? DateTime.now(),
                  icon: IconModel(
                    icon: !isLater ? AppIcons.checkmark : AppIcons.clock,
                    // iconPath: !isLater
                    //     ? Assets.icons.icCheckmark
                    //     : Assets.icons.icClock,
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
                  scheduledTime: e.startTime!.timeRange(e.endTime!),
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
