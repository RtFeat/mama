import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'work_slot.g.dart';

@JsonSerializable()
class WorkSlot extends _WorkSlot with _$WorkSlot {
  @JsonKey(name: 'is_busy')
  final bool isBusy;

  @JsonKey(name: 'work_slot')
  final String workSlot;

  WorkSlot({
    required this.isBusy,
    required this.workSlot,
  });

  factory WorkSlot.fromJson(Map<String, dynamic> json) =>
      _$WorkSlotFromJson(json);

  Map<String, dynamic> toJson() => _$WorkSlotToJson(this);
}

abstract class _WorkSlot with Store {
  @observable
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool isSelected = false;

  @action
  void select(bool value) => isSelected = value;
}
