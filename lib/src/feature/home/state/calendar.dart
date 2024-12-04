import 'package:calendar_view/calendar_view.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'calendar.g.dart';

class CalendarStore extends _CalendarStore with _$CalendarStore {
  CalendarStore({required super.store});
}

abstract class _CalendarStore with Store {
  final DoctorStore store;

  _CalendarStore({required this.store});

  @observable
  DateTime selectedDate = DateTime.now();

  @action
  void setSelectedDate(DateTime value) {
    selectedDate = value;
  }

  @observable
  bool isCalendar = false;

  @action
  void toggleIsCalendar() {
    isCalendar = !isCalendar;
  }

  EventController controller = EventController();

  void dispose() {
    controller.dispose();
  }

  void updateEvents() {
    final DateTime now = DateTime.now();
    final DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));

    store.weekSlots.asMap().forEach((dayIndex, dailySlots) {
      // print('Day Index: $dayIndex, Slots: ${dailySlots.length}');

      for (var slot in dailySlots) {
        // Расчёт даты для текущего слота, добавляя индекс дня недели к начальной дате
        DateTime slotDate = weekStart.add(Duration(days: dayIndex));

        // print('Adding slot: ${slot.workSlot} for date: $slotDate');

        // Создание и добавление события в controller
        controller.add(
          CalendarEventData(
            title: slot.workSlot,
            date: DateTime(slotDate.year, slotDate.month, slotDate.day,
                slot.startTime.hour, slot.startTime.minute),

            startTime: slot.startTime,
            endTime: slot.endTime,
            event: slot.patientFullName ?? 'Доступно', // Или какое-то описание
          ),
        );
      }
    });
  }
}
