import 'package:mobx/mobx.dart';

part 'calendar.g.dart';

class CalendarStore extends _CalendarStore with _$CalendarStore {
  CalendarStore();
}

abstract class _CalendarStore with Store {
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
}
