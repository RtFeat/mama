import 'package:json_annotation/json_annotation.dart';

part 'sleep_cry_cell.g.dart';

@JsonSerializable()
class SleepCryCell {
  @JsonKey(name: 'time')
  final String? title;

  final String? sleep;

  final String? cry;

  @JsonKey(name: 'notes')
  final String? note;

  SleepCryCell({
    this.title,
    this.sleep,
    this.cry,
    this.note,
  });

  factory SleepCryCell.fromJson(Map<String, dynamic> json) =>
      _$SleepCryCellFromJson(json);

  Map<String, dynamic> toJson() => _$SleepCryCellToJson(this);
}
