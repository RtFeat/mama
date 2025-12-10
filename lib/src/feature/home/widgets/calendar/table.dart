import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/services/specialist_consulting/widgets/calendar_cell_widget.dart';

class CustomTableWidget extends StatefulWidget {
  final DoctorStore doctorStore;
  final GlobalKey<MonthViewState> monthViewKey;
  final bool isOnlyCalendar;
  final CalendarStore store;
  const CustomTableWidget({
    super.key,
    required this.store,
    this.isOnlyCalendar = false,
    required this.doctorStore,
    required this.monthViewKey,
  });

  @override
  State<CustomTableWidget> createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends State<CustomTableWidget> {
  @override
  initState() {
    super.initState();
    widget.store.updateEvents();
  }

  List<Events> filterEvents(List<CalendarEventData> events) {
    final now = DateTime.now();

    // Завершённые события: события с `endTime`, которая раньше текущего времени
    final finishedEventsCount = events
        .where((e) => e.endTime != null && e.endTime!.isBefore(now))
        .length;

    // Оставшиеся события: события, которые ещё не начались
    final remainingEventsCount = events
        .where(
            (e) => e.startTime!.isAfter(now)) // Начало позже текущего времени
        .length;

    if (finishedEventsCount == 0 && remainingEventsCount == 0) {
      return [];
    }

    // Возвращаем два списка: завершённые и оставшиеся
    return [
      Events(
          event: remainingEventsCount,
          fillColor: AppColors.lightBlueBackgroundStatus,
          textColor: AppColors.primaryColor),
      Events(
          event: finishedEventsCount,
          fillColor: AppColors.greenLighterBackgroundColor,
          textColor: AppColors.greenTextColor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return CalendarControllerProvider(
        controller: widget.store.controller,
        child: SizedBox(
          height: 600,
          child: MonthView(
            showWeekTileBorder: false,
            weekDayBuilder: (day) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  t.home.list_of_weeks[day][0],
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(color: Colors.black),
                ),
              );
            },
            key: widget.monthViewKey,
            borderColor: AppColors.greyColorMedicard,
            headerBuilder: (date) => const SizedBox.shrink(),
            useAvailableVerticalSpace: true,
            cellBuilder: (date, event, isToday, isInMonth, hideDaysNotInMonth) {
              return CalendarCell(
                  event: event,
                  isToday: isToday,
                  isInMonth: isInMonth,
                  isOnlyCalendar: widget.isOnlyCalendar,
                  data: DayOfWeek(day: date.day, events: filterEvents(event)));
            },
          ),
        ));
  }
}
