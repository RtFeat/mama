import 'package:json_annotation/json_annotation.dart';

part 'feeding_cell.g.dart';

@JsonSerializable()
class FeedingCell {
  @JsonKey(name: 'table')
  final List<FeedingCellTable>? table;

  @JsonKey(name: 'time_to_end_total')
  final String? title;

  FeedingCell({
    this.table,
    this.title,
  });

  factory FeedingCell.fromJson(Map<String, dynamic> json) =>
      _$FeedingCellFromJson(json);

  Map<String, dynamic> toJson() => _$FeedingCellToJson(this);
}

@JsonSerializable()
class FeedingCellTable {
  @JsonKey(name: 'time')
  final String? title;

  final String? chest;

  final String? food;

  final String? lure;

  @JsonKey(name: 'notes')
  final String? note;

  FeedingCellTable({
    this.title,
    this.chest,
    this.food,
    this.lure,
    this.note,
  });

  factory FeedingCellTable.fromJson(Map<String, dynamic> json) =>
      _$FeedingCellTableFromJson(json);

  Map<String, dynamic> toJson() => _$FeedingCellTableToJson(this);
}
