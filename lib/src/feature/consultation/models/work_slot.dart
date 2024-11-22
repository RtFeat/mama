import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'work_slot.g.dart';

@JsonSerializable()
class WorkSlot extends _WorkSlot with _$WorkSlot {
  @JsonKey(name: 'is_busy')
  final bool isBusy;

  @JsonKey(name: 'consultation_id')
  final String? consultationId;

  @JsonKey(name: 'consultation_type')
  final String? consultationType;

  @JsonKey(name: 'patient_full_name')
  final String? patientFullName;

  WorkSlot({
    required this.isBusy,
    super.workSlot,
    this.consultationId,
    this.consultationType,
    this.patientFullName,
  });

  factory WorkSlot.fromJson(Map<String, dynamic> json) =>
      _$WorkSlotFromJson(json);

  Map<String, dynamic> toJson() => _$WorkSlotToJson(this);
}

abstract class _WorkSlot with Store {
  _WorkSlot({this.workSlot = ''});

  @JsonKey(name: 'work_slot')
  @observable
  String workSlot = '';

  @action
  void setWorkSlot(String value) => workSlot = value;

  @observable
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool isSelected = false;

  @action
  void select(bool value) => isSelected = value;

  DateTime get startTime {
    final parts = workSlot.split(' - ');
    final timeParts = parts[0].split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(timeParts[0]),
        int.parse(timeParts[1]));
  }
}
