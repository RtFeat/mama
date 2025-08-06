import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class WeekTableWidget extends StatelessWidget {
  const WeekTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final EventController _eventController = EventController();
    final List<CalendarEventData> _events = [
      CalendarEventData(
        date: DateTime.now(),
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        title: 'Event A',
        color: Colors.red,
      ),
      CalendarEventData(
        date: DateTime.now(),
        startTime: DateTime.now().add(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        title: 'Event B',
        color: Colors.green,
      ),
    ];

    _eventController.addAll(_events);

    return CalendarControllerProvider(
        controller: _eventController,
        child: SizedBox(
          height: 520,
          child: WeekView(
            weekNumberBuilder: (firstDayOfWeek) => SizedBox.shrink(),
            weekTitleHeight: 30,
            controller: _eventController,
            heightPerMinute: 0.3,
            timeLineBuilder: (date) {
              // if (date.hour >= 23 || date.hour <= 1) {
              //   return Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8),
              //     child: Text(
              //       '00:00',
              //       style: textTheme.labelSmall,
              //     ),
              //   );
              // }
              if (date.hour % 3 == 0 && date.minute == 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    '${date.hour.toString().padLeft(2, '0')}:00',
                    style: textTheme.labelSmall,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            weekDayBuilder: (date) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${t.trackers.list_of_weeks[date.weekday - 1]} ${date.day}',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall
                      ?.copyWith(fontWeight: FontWeight.w400),
                  maxLines: 1,
                ),
              );
            },
            eventTileBuilder: (date, events, boundry, start, end) {
              // Return your widget to display as event tile.
              // return Container();
              return Container(
                width: 50,
                height: 50,
                color: Colors.red,
              );
            },
            fullDayEventBuilder: (events, date) {
              // Return your widget to display full day event view.
              return Container(
                width: 50,
                height: 50,
                color: Colors.yellow,
              );
            },
            showLiveTimeLineInAllDays:
                true, // To display live time line in all pages in week view.
            minDay: DateTime(1990),
            maxDay: DateTime(2050),
            initialDay: DateTime.now(),
            onEventTap: (events, date) => print(events),
            onEventDoubleTap: (events, date) => print(events),
            onDateLongPress: (date) => print(date),
            startDay: WeekDays.monday, // To change the first day of the week.
            startHour: 0, // To set the first hour displayed (ex: 05:00)
            endHour: 24, // To set the end hour displayed
            showVerticalLines: true, // Show the vertical line between days.
            weekPageHeaderBuilder: (context, date) {
              return SizedBox.shrink();
            },

            keepScrollOffset: true,
          ),
        ));
  }
}
