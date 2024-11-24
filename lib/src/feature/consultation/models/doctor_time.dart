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

  final WeekDay? monday;

  final WeekDay? tuesday;

  final WeekDay? wednesday;

  final WeekDay? thursday;

  final WeekDay? friday;

  final WeekDay? saturday;

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
    for (WorkSlot? e in slots ?? []) {
      e?.select(false);
    }
  }

  @computed
  bool get isSelectedDate => slots?.any((e) => e.isSelected) ?? false;

  @computed
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<WorkSlot>? get slots => switch (selectedTime.weekday) {
        1 => monday?.workSlots,
        2 => tuesday?.workSlots,
        3 => wednesday?.workSlots,
        4 => thursday?.workSlots,
        5 => friday?.workSlots,
        6 => saturday?.workSlots,
        7 => sunday?.workSlots,
        _ => [],
      };
}
