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
    store.weekConsultations.asMap().forEach((dayIndex, dailySlots) {
      // print('Day Index: $dayIndex, Slots: ${dailySlots.length}');

      for (var slot in dailySlots) {
        // Расчёт даты для текущего слота, добавляя индекс дня недели к начальной дате
        DateTime slotDate = store.weekStart.add(Duration(days: dayIndex));

        // print('Adding slot: ${slot.workSlot} for date: $slotDate');

        // startedAt: e.slotTime(doctorStore.weekStart, true),

        final DateTime slotTime =
            slot.dateTime ?? slot.slotTime(store.weekStart, true);

        // Создание и добавление события в controller
        controller.add(
          CalendarEventData(
            title: slot.consultationTime ?? '',
            date: slot.dateTime ??
                DateTime(slotDate.year, slotDate.month, slotDate.day,
                    slotTime.hour, slotTime.minute),
            description: slot.id,
            startTime:
                slot.dateTime ?? slot.slotTime(slot.dateTime ?? slotDate, true),
            endTime: slot.slotTime(slot.dateTime ?? slotDate, false),
            event: slot.fullName ?? 'Доступно', // Или какое-то описание
          ),
        );
      }
    });
  }
}
