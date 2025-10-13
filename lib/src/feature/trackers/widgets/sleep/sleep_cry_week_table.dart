import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mobx/mobx.dart';

class SleepCryWeekTable extends StatefulWidget {
  final DateTime startOfWeek;
  const SleepCryWeekTable({super.key, required this.startOfWeek});

  @override
  State<SleepCryWeekTable> createState() => _SleepCryWeekTableState();
}

class _SleepCryWeekTableState extends State<SleepCryWeekTable> {
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  late EventController _controller;
  List<ReactionDisposer>? _disposers;

  @override
  void initState() {
    super.initState();
    _controller = EventController();
    startOfWeek = widget.startOfWeek;
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    // Откладываем инициализацию реакций до первого построения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setupReactions();
        _loadData();
      }
    });
  }

  void _setupReactions() {
    final sleepStore = context.read<SleepTableStore>();
    final cryStore = context.read<CryTableStore>();
    
    _disposers = [
      // Реагируем на изменения в sleepStore
      reaction(
        (_) => sleepStore.listData.length,
        (_) {
          if (mounted) {
            _updateEvents();
          }
        },
      ),
      // Реагируем на изменения в cryStore
      reaction(
        (_) => cryStore.listData.length,
        (_) {
          if (mounted) {
            _updateEvents();
          }
        },
      ),
    ];
  }

  @override
  void didUpdateWidget(SleepCryWeekTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startOfWeek != widget.startOfWeek) {
      print('SleepCryWeekTable didUpdateWidget: Date changed from ${oldWidget.startOfWeek} to ${widget.startOfWeek}');
      startOfWeek = widget.startOfWeek;
      endOfWeek = startOfWeek.add(const Duration(days: 6));
      // Принудительно перезагружаем данные при изменении даты
      _forceReloadData();
      _updateEvents();
    }
  }

  @override
  void dispose() {
    _disposers?.forEach((d) => d());
    _controller.dispose();
    super.dispose();
  }

  void _loadData() {
    final childId = context.read<UserStore>().selectedChild?.id;
    if (childId != null) {
      _loadSleepData(childId);
      _loadCryData(childId);
    }
  }

  void _forceReloadData() {
    final childId = context.read<UserStore>().selectedChild?.id;
    print('SleepCryWeekTable _forceReloadData: childId = $childId, startOfWeek = $startOfWeek, endOfWeek = $endOfWeek');
    if (childId != null) {
      // Принудительно очищаем данные и загружаем заново
      final sleepStore = context.read<SleepTableStore>();
      final cryStore = context.read<CryTableStore>();
      
      print('SleepCryWeekTable _forceReloadData: Clearing data - sleep: ${sleepStore.listData.length}, cry: ${cryStore.listData.length}');
      
      // Очищаем данные
      sleepStore.listData.clear();
      cryStore.listData.clear();
      
      // Загружаем данные заново
      _loadSleepData(childId);
      _loadCryData(childId);
    }
  }

  void _updateEvents() {
    if (!mounted) return;
    
    // Очищаем предыдущие события
    _controller.removeWhere((event) => true);
    
    // Добавляем новые события
    final sleepEvents = _buildSleepEvents();
    final cryEvents = _buildCryEvents();
    
    
    if (sleepEvents.isNotEmpty || cryEvents.isNotEmpty) {
      _controller.addAll([...sleepEvents, ...cryEvents]);
    }
  }

  void _loadSleepData(String childId) {
    final sleepStore = context.read<SleepTableStore>();
    sleepStore.loadPage(newFilters: [
      SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
    ]);
  }

  void _loadCryData(String childId) {
    final cryStore = context.read<CryTableStore>();
    cryStore.loadPage(newFilters: [
      SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
    ]);
  }

  List<CalendarEventData> _buildSleepEvents() {
    if (!mounted) return [];
    
    final sleepStore = context.read<SleepTableStore>();
    final List<CalendarEventData> events = [];

    final DateTime weekStart = startOfWeek;
    final DateTime weekEnd = endOfWeek.add(const Duration(hours: 23, minutes: 59));
    

    for (final entity in sleepStore.listData) {
      // Используем timeEnd для получения правильной даты (как в отдельных экранах)
      DateTime? end = _parseDateTime(entity.timeEnd);
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
        start = _parseDateTime(entity.timeToStart);
      }
      
      if (start == null) continue;
      
      // Поддержка перехода через полночь
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      
      // Отсекаем по выбранной неделе (как в отдельных экранах)
      DateTime intervalStart = start.isBefore(weekStart) ? weekStart : start;
      DateTime intervalEnd = end.isAfter(weekEnd) ? weekEnd : end;
      if (!intervalEnd.isAfter(intervalStart)) continue;

      DateTime dayCursor = DateTime(intervalStart.year, intervalStart.month, intervalStart.day);
      while (dayCursor.isBefore(intervalEnd)) {
        final DateTime dayStart = dayCursor.isBefore(intervalStart)
            ? intervalStart
            : DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 0, 0);
        final DateTime dayEndLimit = DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 23, 59);
        final DateTime dayEnd = intervalEnd.isBefore(dayEndLimit) ? intervalEnd : dayEndLimit;
        if (dayEnd.isAfter(dayStart)) {
          DateTime chunkStart = dayStart;
          while (chunkStart.isBefore(dayEnd)) {
            final DateTime hourCeil = DateTime(chunkStart.year, chunkStart.month, chunkStart.day, chunkStart.hour)
                .add(const Duration(hours: 1));
            final DateTime chunkEnd = dayEnd.isBefore(hourCeil) ? dayEnd : hourCeil;
            events.add(CalendarEventData(
              date: DateTime(chunkStart.year, chunkStart.month, chunkStart.day),
              startTime: chunkStart,
              endTime: chunkEnd,
              title: t.trackers.sleep,
              color: AppColors.purpleBrighterBackgroundColor,
            ));
            chunkStart = chunkEnd;
          }
        }
        dayCursor = DateTime(dayCursor.year, dayCursor.month, dayCursor.day).add(const Duration(days: 1));
      }
    }

    return events;
  }

  List<CalendarEventData> _buildCryEvents() {
    if (!mounted) return [];
    
    final cryStore = context.read<CryTableStore>();
    final List<CalendarEventData> events = [];

    final DateTime weekStart = startOfWeek;
    final DateTime weekEnd = endOfWeek.add(const Duration(hours: 23, minutes: 59));

    for (final entity in cryStore.listData) {
      // Используем timeEnd для получения правильной даты (как в отдельных экранах)
      DateTime? end = _parseDateTime(entity.timeEnd);
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
        start = _parseDateTime(entity.timeToStart);
      }
      
      if (start == null) continue;
      
      // Поддержка перехода через полночь
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      
      // Отсекаем по выбранной неделе (как в отдельных экранах)
      DateTime intervalStart = start.isBefore(weekStart) ? weekStart : start;
      DateTime intervalEnd = end.isAfter(weekEnd) ? weekEnd : end;
      if (!intervalEnd.isAfter(intervalStart)) continue;

      DateTime dayCursor = DateTime(intervalStart.year, intervalStart.month, intervalStart.day);
      while (dayCursor.isBefore(intervalEnd)) {
        final DateTime dayStart = dayCursor.isBefore(intervalStart)
            ? intervalStart
            : DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 0, 0);
        final DateTime dayEndLimit = DateTime(dayCursor.year, dayCursor.month, dayCursor.day, 23, 59);
        final DateTime dayEnd = intervalEnd.isBefore(dayEndLimit) ? intervalEnd : dayEndLimit;
        if (dayEnd.isAfter(dayStart)) {
          DateTime chunkStart = dayStart;
          while (chunkStart.isBefore(dayEnd)) {
            final DateTime hourCeil = DateTime(chunkStart.year, chunkStart.month, chunkStart.day, chunkStart.hour)
                .add(const Duration(hours: 1));
            final DateTime chunkEnd = dayEnd.isBefore(hourCeil) ? dayEnd : hourCeil;
            events.add(CalendarEventData(
              date: DateTime(chunkStart.year, chunkStart.month, chunkStart.day),
              startTime: chunkStart,
              endTime: chunkEnd,
              title: t.trackers.crying,
              color: AppColors.redCryColor,
            ));
            chunkStart = chunkEnd;
          }
        }
        dayCursor = DateTime(dayCursor.year, dayCursor.month, dayCursor.day).add(const Duration(days: 1));
      }
    }

    return events;
  }

  DateTime? _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    try {
      return DateTime.parse(dateTimeString);
    } catch (_) {
      return null;
    }
  }

  @override
Widget build(BuildContext context) {
  final TextTheme textTheme = Theme.of(context).textTheme;

  return CalendarControllerProvider(
    controller: _controller,
    child: Container(
      height: 520,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Оборачиваем WeekView в Container с явными размерами
              Container(
                width: constraints.maxWidth,
                height: 520,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme: const DividerThemeData(
                      color: Colors.transparent,
                      thickness: 0,
                      space: 0,
                    ),
                  ),
                  child: WeekView(
                    key: ValueKey('sleep_cry_week_${startOfWeek.toIso8601String()}'),
                    controller: _controller,
                    heightPerMinute: 0.3,
                    weekNumberBuilder: (firstDayOfWeek) {
                      print('SleepCryWeekTable WeekView weekNumberBuilder: firstDayOfWeek = $firstDayOfWeek');
                      return const SizedBox.shrink();
                    },
                    weekTitleHeight: 30,
                    timeLineBuilder: (date) {
                      if (date.hour % 3 == 0 && date.minute == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            '${date.hour.toString().padLeft(2, '0')}:00',
                            style: textTheme.labelSmall,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    weekDayBuilder: (date) {
                      print('SleepCryWeekTable WeekView weekDayBuilder: date = $date');
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${t.trackers.list_of_weeks[date.weekday - 1]} ${date.day}',
                          textAlign: TextAlign.center,
                          style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
                          maxLines: 1,
                        ),
                      );
                    },
                    eventTileBuilder: (date, events, boundry, start, end) {
                      final Color color = events.isNotEmpty
                          ? (events.first.color ?? AppColors.purpleBrighterBackgroundColor)
                          : AppColors.purpleBrighterBackgroundColor;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        color: color,
                      );
                    },
                    fullDayEventBuilder: (events, date) {
                      return const SizedBox.shrink();
                    },
                    showLiveTimeLineInAllDays: false, // Отключаем live timeline
                    minDay: DateTime(1990),
                    maxDay: DateTime(2050),
                    initialDay: startOfWeek,
                    startDay: WeekDays.monday,
                    startHour: 0,
                    endHour: 24,
                    showVerticalLines: true,
                    weekPageHeaderBuilder: (context, date) => const SizedBox.shrink(),
                    keepScrollOffset: false, // Изменяем на false
                  ),
                ),
              ),
              // Остальные Positioned виджеты остаются без изменений
              Positioned(
                top: 30,
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
          );
        },
      ),
    ),
  );
}
}