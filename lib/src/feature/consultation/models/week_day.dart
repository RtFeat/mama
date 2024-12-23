// import 'package:json_annotation/json_annotation.dart';
// import 'package:mama/src/data.dart';

// part 'week_day.g.dart';

// @JsonSerializable()
// class WeekDay {
//   @JsonKey(name: 'is_work')
//   final bool isWork;

//   @JsonKey(name: 'work_slots')
//   final List<WorkSlot> workSlots;

//   WeekDay({
//     required this.isWork,
//     required this.workSlots,
//   });

//   factory WeekDay.fromJson(Map<String, dynamic> json) =>
//       _$WeekDayFromJson(json);

//   Map<String, dynamic> toJson() => _$WeekDayToJson(this);
// }

import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'week_day.g.dart';

@JsonSerializable()
class WeekDay extends _WeekDay with _$WeekDay {
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? title;

  WeekDay({
    this.title,
    super.isWork = false,
    required super.workSlots,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) =>
      _$WeekDayFromJson(json);

  Map<String, dynamic> toJson() => _$WeekDayToJson(this);
}

abstract class _WeekDay with Store {
  _WeekDay({
    required this.workSlots,
    required this.isWork,
  });

  @JsonKey(name: 'work_slots', toJson: _toJson, fromJson: _workSlotsfromJson)
  @observable
  ObservableList<WorkSlot> workSlots = ObservableList();

  static List<WorkSlot> _toJson(v) {
    return v.toList();
  }

  static ObservableList<WorkSlot> _workSlotsfromJson(List? v) {
    final workSlots = v?.map((e) => WorkSlot.fromJson(e)).toList();
    return ObservableList.of(workSlots ?? []);
  }

  @observable
  @JsonKey(
      name: 'consultations',
      includeToJson: false,
      fromJson: _consultationsFromJson)
  ObservableList<ConsultationSlot> consultations = ObservableList();

  static ObservableList<ConsultationSlot> _consultationsFromJson(List? v) {
    final consultations = v?.map((e) => ConsultationSlot.fromJson(e)).toList();
    return ObservableList.of(consultations ?? []);
  }

  @action
  void updateWorkSlots(List<WorkSlot> workSlots) {
    this.workSlots = ObservableList.of(workSlots);
  }

  @action
  void updateConsultations(List<ConsultationSlot> consultations) {
    this.consultations = ObservableList.of(consultations);
  }

  // @observable
  // @JsonKey(includeToJson: false, includeFromJson: false)
  // ObservableList<WorkSlot> workSlotsObs = ObservableList();

  @JsonKey(
    name: 'is_work',
  )
  @observable
  bool? isWork;

  @action
  void setIsWork(bool value) => isWork = value;
}
