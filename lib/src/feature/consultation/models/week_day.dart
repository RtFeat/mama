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
    required super.workSlots,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) =>
      _$WeekDayFromJson(json);

  Map<String, dynamic> toJson() => _$WeekDayToJson(this);
}

abstract class _WeekDay with Store {
  _WeekDay({
    required this.workSlots,
  });

  @JsonKey(name: 'work_slots', toJson: _toJson, fromJson: _fromJson)
  ObservableList<WorkSlot> workSlots = ObservableList();

  static List<WorkSlot> _toJson(v) {
    return v.toList();
  }

  static ObservableList<WorkSlot> _fromJson(v) {
    return ObservableList.of(v);
  }

  // @observable
  // @JsonKey(includeToJson: false, includeFromJson: false)
  // ObservableList<WorkSlot> workSlotsObs = ObservableList();

  @JsonKey(name: 'is_work')
  @observable
  bool isWork = false;

  @action
  void setIsWork(bool value) => isWork = value;
}
