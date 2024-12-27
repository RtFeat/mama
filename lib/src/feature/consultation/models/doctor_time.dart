import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'doctor_time.g.dart';

@JsonSerializable()
class DoctorWorkTime extends _DoctorWorkTime with _$DoctorWorkTime {
  final String? id;

  @JsonKey(name: 'week_start')
  final DateTime? weekStart;

  DoctorWorkTime({
    required this.id,
    required super.monday,
    required super.tuesday,
    required super.wednesday,
    required super.thursday,
    required super.friday,
    required super.saturday,
    required super.sunday,
    this.weekStart,
  });

  factory DoctorWorkTime.fromJson(Map<String, dynamic> json) =>
      _$DoctorWorkTimeFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorWorkTimeToJson(this);
}

abstract class _DoctorWorkTime with Store {
  _DoctorWorkTime({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  @JsonKey(name: 'Monday')
  final WeekDay? monday;

  @JsonKey(name: 'Tuesday')
  final WeekDay? tuesday;

  @JsonKey(name: 'Wednesday')
  final WeekDay? wednesday;

  @JsonKey(name: 'Thursday')
  final WeekDay? thursday;

  @JsonKey(name: 'Friday')
  final WeekDay? friday;

  @JsonKey(name: 'Saturday')
  final WeekDay? saturday;

  @JsonKey(name: 'Sunday')
  final WeekDay? sunday;

  @observable
  @JsonKey(includeToJson: false, includeFromJson: false)
  DateTime selectedTime = DateTime.now();

  @action
  void setSelectedTime(DateTime value) {
    selectedTime = value;
  }

  @computed
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? get isWork => switch (selectedTime.weekday) {
        1 => monday?.isWork,
        2 => tuesday?.isWork,
        3 => wednesday?.isWork,
        4 => thursday?.isWork,
        5 => friday?.isWork,
        6 => saturday?.isWork,
        7 => sunday?.isWork,
        _ => false,
      };

  @action
  void markAllAsNotSelected() {
    for (WorkSlot? e in intervalSlots) {
      e?.select(false);
    }
  }

  @computed
  bool get isSelectedDate => intervalSlots.any((e) => e.isSelected);

  @computed
  @JsonKey(includeToJson: false, includeFromJson: false)
  ObservableList<WorkSlot>? get slots => switch (selectedTime.weekday) {
        1 => monday?.workSlots,
        2 => tuesday?.workSlots,
        3 => wednesday?.workSlots,
        4 => thursday?.workSlots,
        5 => friday?.workSlots,
        6 => saturday?.workSlots,
        7 => sunday?.workSlots,
        _ => ObservableList(),
      };

  ObservableList<WorkSlot>? slotByDay(int day) => switch (day) {
        1 => monday?.workSlots,
        2 => tuesday?.workSlots,
        3 => wednesday?.workSlots,
        4 => thursday?.workSlots,
        5 => friday?.workSlots,
        6 => saturday?.workSlots,
        7 => sunday?.workSlots,
        _ => ObservableList(),
      };

  @observable
  @JsonKey(includeToJson: false, includeFromJson: false)
  int selectedConsultationType = 0;

  @action
  void setSelectedConsultationType(int value) =>
      selectedConsultationType = value;

  @computed
  ObservableList<WorkSlot> get intervalSlots {
    if (slots == null || slots!.isEmpty) {
      return ObservableList<WorkSlot>();
    }

    final intervalMinutes = switch (selectedConsultationType) {
      0 => 15,
      1 => 60,
      _ => 30,
    };

    final List<WorkSlot> result = [];

    for (final slot in slots!) {
      final startTime = slot.startTime;
      final endTime = slot.endTime;

      var currentStart = startTime;

      while (currentStart.isBefore(endTime)) {
        final currentEnd = currentStart.add(Duration(minutes: intervalMinutes));
        if (currentEnd.isAfter(endTime)) break;

        final formattedStart =
            '${currentStart.hour.toString().padLeft(2, '0')}:${currentStart.minute.toString().padLeft(2, '0')}';
        final formattedEnd =
            '${currentEnd.hour.toString().padLeft(2, '0')}:${currentEnd.minute.toString().padLeft(2, '0')}';

        final newWorkSlot = WorkSlot(
          workSlot: '$formattedStart - $formattedEnd',
          isBusy: slot.isBusy,
          consultationId: slot.consultationId,
          consultationType: slot.consultationType,
          patientFullName: slot.patientFullName,
        );

        result.add(newWorkSlot);
        currentStart = currentEnd;
      }
    }

    // Убираем дублирующиеся записи
    final uniqueSlots = result.toSet().toList();
    return ObservableList<WorkSlot>.of(uniqueSlots);
  }

  @computed
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<ConsultationSlot> get consultationSlots =>
      switch (selectedTime.weekday) {
        1 => monday?.consultations ?? [],
        2 => tuesday?.consultations ?? [],
        3 => wednesday?.consultations ?? [],
        4 => thursday?.consultations ?? [],
        5 => friday?.consultations ?? [],
        6 => saturday?.consultations ?? [],
        7 => sunday?.consultations ?? [],
        _ => [],
      };

  @action
  void updateConsultations(int weekday, List<WorkSlot> consultationSlots) {
    switch (weekday) {
      case 1:
        monday?.updateWorkSlots(consultationSlots);
        break;
      case 2:
        tuesday?.updateWorkSlots(consultationSlots);
        break;
      case 3:
        wednesday?.updateWorkSlots(consultationSlots);
        break;
      case 4:
        thursday?.updateWorkSlots(consultationSlots);
        break;
      case 5:
        friday?.updateWorkSlots(consultationSlots);
        break;
      case 6:
        saturday?.updateWorkSlots(consultationSlots);
        break;
      case 7:
        sunday?.updateWorkSlots(consultationSlots);
        break;
    }
  }
}
