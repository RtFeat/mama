import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class CryWeekTableWidget extends StatelessWidget {
  final DateTime startOfWeek;
  const CryWeekTableWidget({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final DateTime base = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final DateTime weekEnd = base.add(const Duration(days: 6, hours: 23, minutes: 59));

    final cryTableStore = context.read<CryTableStore>();

    return Observer(builder: (_) {
      final EventController eventController = EventController();
      final List<CalendarEventData> events = [];
      
      // Принудительно обновляем события при изменении данных

      for (final entity in cryTableStore.listData) {
        // Используем timeEnd для получения правильной даты
        DateTime? end = _tryParse(entity.timeEnd);
        if (end == null) continue;
        
        // Создаем правильную дату для времени начала, используя дату из timeEnd
        DateTime? start;
        if (entity.timeToStart != null && entity.timeToStart!.contains(':')) {
          final timeParts = entity.timeToStart!.split(':');
          if (timeParts.length == 2) {
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);
            start = DateTime(end.year, end.month, end.day, hour, minute);
          }
        } else {
          start = _tryParse(entity.timeToStart);
        }
        
        if (start == null) continue;
        // Поддержка перехода через полночь
        if (end.isBefore(start)) {
          end = end.add(const Duration(days: 1));
        }

        // Отсекаем по выбранной неделе
        DateTime intervalStart = start.isBefore(base) ? base : start;
        DateTime intervalEnd = end.isAfter(weekEnd) ? weekEnd : end;
        if (!intervalEnd.isAfter(intervalStart)) continue;

        // Разбиваем на календарные дни
        DateTime dayCursor = DateTime(intervalStart.year, intervalStart.month, intervalStart.day);
        while (dayCursor.isBefore(intervalEnd)) {
          final DateTime dayStart = dayCursor.isBefore(intervalStart)
              ? intervalStart
              : DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 0, 0);
          final DateTime dayEndLimit = DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 23, 59);
          final DateTime dayEnd = intervalEnd.isBefore(dayEndLimit) ? intervalEnd : dayEndLimit;

          if (dayEnd.isAfter(dayStart)) {
            // Разбиваем внутри дня по часовым "кубикам" аналогично Sleep
            DateTime chunkStart = dayStart;
            while (chunkStart.isBefore(dayEnd)) {
              final DateTime hourCeil = DateTime(chunkStart.year, chunkStart.month, chunkStart.day, chunkStart.hour)
                  .add(const Duration(hours: 1));
              final DateTime chunkEnd = dayEnd.isBefore(hourCeil) ? dayEnd : hourCeil;
              events.add(
                CalendarEventData(
                  date: DateTime(chunkStart.year, chunkStart.month, chunkStart.day),
                  startTime: chunkStart,
                  endTime: chunkEnd,
                  title: t.trackers.crying,
                  color: AppColors.redCryColor,
                ),
              );
              chunkStart = chunkEnd;
            }
          }

          dayCursor = DateTime(dayCursor.year, dayCursor.month, dayCursor.day).add(const Duration(days: 1));
        }
      }

      eventController.addAll(events);

      return CalendarControllerProvider(
          controller: eventController,
          child: SizedBox(
            height: 520,
            child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
                thickness: 0,
                space: 0,
              ),
            ),
            child: Stack(
            children: [
            WeekView(
            key: ValueKey('cry_week_${base.toIso8601String()}'),
            weekNumberBuilder: (firstDayOfWeek) => const SizedBox.shrink(),
            weekTitleHeight: 30,
            controller: eventController,
            heightPerMinute: 0.3,
            // возвращаем hourIndicator по умолчанию, чтобы сетка оставалась
            timeLineBuilder: (date) {
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
                  style:
                      textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
                  maxLines: 1,
                ),
              );
            },
            eventTileBuilder: (date, events, boundry, start, end) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                color: AppColors.redCryColor,
              );
            },
            fullDayEventBuilder: (events, date) {
              return const SizedBox.shrink();
            },
            showLiveTimeLineInAllDays: true,
            minDay: DateTime(1990),
            maxDay: DateTime(2050),
            initialDay: base,
            onEventTap: (events, date) => {},
            onEventDoubleTap: (events, date) => {},
            onDateLongPress: (date) => {},
            startDay: WeekDays.monday,
            startHour: 0,
            endHour: 24,
            showVerticalLines: true,
            weekPageHeaderBuilder: (context, date) {
              return const SizedBox.shrink();
            },
            keepScrollOffset: true,
            ),
            // Маскируем нижнюю границу all-day секции (2px), не трогая hourIndicator
            Positioned(
              top: 30, // равен weekTitleHeight
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SizedBox(
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            // Принудительные метки 00:00 сверху и снизу как в Sleep
            Positioned(
              top: 34,
              left: 8,
              child: IgnorePointer(
                child: Text('00:00', style: textTheme.labelSmall),
              ),
            ),
            Positioned(
              bottom: 34,
              left: 8,
              child: IgnorePointer(
                child: Text('00:00', style: textTheme.labelSmall),
              ),
            ),
            ],
            ), // Stack
          ), // Theme
        ), // SizedBox
      ); // CalendarControllerProvider
    });
  }

  DateTime? _tryParse(String? v) {
    if (v == null || v.isEmpty) return null;
    try {
      if (v.contains('T')) {
        final dt = DateTime.parse(v);
        return dt.isUtc ? dt.toLocal() : dt.toLocal();
      }
      if (v.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(v).toLocal();
      }
      if (v.contains(':')) {
        // Если это только время в формате HH:mm, создаем дату на сегодня
        final timeParts = v.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
      }
      return DateFormat('yyyy-MM-dd').parse(v).toLocal();
    } catch (_) {
      return null;
    }
  }
}


