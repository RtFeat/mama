import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CalendarCell extends StatelessWidget {
  final bool isInMonth;
  final bool isToday;
  final DayOfWeek data;
  final bool isOnlyCalendar;
  final List<CalendarEventData<Object?>> event;

  const CalendarCell({
    super.key,
    required this.isToday,
    required this.isInMonth,
    required this.data,
    this.isOnlyCalendar = false,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return GestureDetector(
      onTap: () {
        if (isOnlyCalendar) {
          if (event.isNotEmpty) {
            context.pushNamed(AppViews.specialistSlots, extra: {
              'event': event,
            });
          }
        } else {
          if (event.isNotEmpty && event.first.description != null) {
            logger.info(event.first);
            context.pushNamed(AppViews.consultation, extra: {
              'consultation': Consultation(
                id: event.first.description,
                startedAt: event.first.startTime,
                endedAt: event.first.endTime,
              )
            });
          }
        }
      },
      child: Column(
        children: [
          isToday
              ? CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: AutoSizeText(
                      '${data.day}',
                      minFontSize: 4,
                      style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    data.day.toString(),
                    style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: isInMonth ? Colors.black : Colors.grey),
                  ),
                ),
          5.h,
          data.events.isEmpty
              ? const Expanded(child: SizedBox())
              : Expanded(
                  child: Column(
                    children: data.events
                        .map((c) => _CellContainer(
                              data: c,
                            ))
                        .toList(),
                  ),
                ),
          5.h
        ],
      ),
    );
  }
}

class _CellContainer extends StatelessWidget {
  final Events data;

  const _CellContainer({required this.data});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: SizedBox(
          width: 38,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: data.fillColor),
            child: Center(
              child: Text(
                data.event.toString(),
                style: textTheme.labelSmall?.copyWith(color: data.textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
