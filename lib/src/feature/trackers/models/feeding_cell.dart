import 'package:json_annotation/json_annotation.dart';

part 'feeding_cell.g.dart';

@JsonSerializable()
class FeedingCell {
  @JsonKey(name: 'time')
  final String? title;

  final String? chest;

  final String? food;

  final String? lure;

  @JsonKey(name: 'notes')
  final String? note;

  FeedingCell({
    this.title,
    this.chest,
    this.food,
    this.lure,
    this.note,
  });

  factory FeedingCell.fromJson(Map<String, dynamic> json) =>
      _$FeedingCellFromJson(json);

  Map<String, dynamic> toJson() => _$FeedingCellToJson(this);
}
