import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'schedule.g.dart';

class ScheduleViewStore extends _ScheduleViewStore with _$ScheduleViewStore {
  ScheduleViewStore({
    required super.apiClient,
  });
}

abstract class _ScheduleViewStore with Store {
  final ApiClient apiClient;

  _ScheduleViewStore({
    required super.apiClient,
  });

  @observable
  bool isCollapsed = false;

  @action
  void toggleCollapsed() => isCollapsed = !isCollapsed;

  final List<WeekDay> weeks = t.home.list_of_weeks
      .map((e) => WeekDay(title: e, workSlots: ObservableList()))
      .toList();

  @computed
  ObservableList<String> get workSlots => ObservableList.of(
        weeks
            .expand((week) => week.workSlots
                .map((slot) => slot.startTime.timeRange(slot.endTime)))
            .toSet(),
      );

  @action
  void updateWorkSlots(String slotTime) {
    for (var week in weeks) {
      if (week.isWork ?? true) {
        final alreadyExists =
            week.workSlots.any((slot) => slot.workSlot == slotTime);
        if (!alreadyExists) {
          week.workSlots.add(WorkSlot(isBusy: true, workSlot: slotTime));
        }
      }
    }
  }

  @action
  void removeWorkSlots(int i) {
    for (var week in weeks) {
      if (week.isWork ?? true) {
        week.workSlots.removeAt(i);
      }
    }
  }

  @observable
  int workTime = 0;

  @action
  void setWorkTime(int value) => workTime = value;

  @computed
  ObservableList<List<Map<String, dynamic>>> get distributedSlots {
    return ObservableList.of(
      workSlots
          .map((slot) => _splitTimeSlotWithOverflow(slot, workTime))
          .toList(),
    );
  }

  /// Распределяет временные интервалы и помечает переполненные
  List<Map<String, dynamic>> _splitTimeSlotWithOverflow(
      String slot, int intervalMinutes) {
    if (intervalMinutes <= 0) return [];

    final parts = slot.split(' - ');
    if (parts.length != 2) return [];

    final start = _parseTime(parts[0]);
    final end = _parseTime(parts[1]);

    if (start == null || end == null || start.isAfter(end)) return [];

    final result = <Map<String, dynamic>>[];
    var currentTime = start;

    while (true) {
      final nextTime = currentTime.add(Duration(minutes: intervalMinutes));
      if (nextTime.isAfter(end)) {
        // Добавляем переполненный слот
        result.add({
          'start': _formatTime(currentTime),
          'end': _formatTime(nextTime),
          'overflow': true,
        });
        break;
      }

      result.add({
        'start': _formatTime(currentTime),
        'end': _formatTime(nextTime),
        'overflow': false,
      });
      currentTime = nextTime;
    }

    return result;
  }

  /// Парсинг времени из строки вида "HH:mm"
  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(0, 1, 1, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Форматирование времени в строку "HH:mm"
  String _formatTime(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future updateWorkTime(BuildContext context) async {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    // Текущее UTC время
    final now = DateTime.now().toUtc();

    // Определяем начало недели в UTC
    final daysToSubtract = (now.weekday - 1) % 7; // Понедельник — 1
    final mondayUtc = DateTime.utc(
      now.year,
      now.month,
      now.day - daysToSubtract,
      0, 0, 0, 0, // Устанавливаем начало дня
    );

    // Выполняем запрос
    ApiClient.patch(Endpoint().updateDoctorWorkTime, body: {
      'monday': weeks[0],
      'tuesday': weeks[1],
      'wednesday': weeks[2],
      'thursday': weeks[3],
      'friday': weeks[4],
      'saturday': weeks[5],
      'sunday': weeks[6],
      'week_start': mondayUtc.toIso8601String(),
    }).then((v) {
      if (context.mounted) {
        if (v?['status_code'] == 500) {
          DelightToastBar(
            autoDismiss: true,
            builder: (context) => ToastCard(
              title: Text(
                t.consultation.cantChangeCurrentWeek,
                style: textTheme.titleSmall,
              ),
            ),
          ).show(context);
        } else {
          DelightToastBar(
            autoDismiss: true,
            builder: (context) => ToastCard(
              title: Text(
                t.consultation.scheduleSaved,
                style: textTheme.titleSmall,
              ),
            ),
          ).show(context);
        }
      }
    });
  }
}
