// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'evolution_table_cell.g.dart';

@JsonSerializable()
class EvolutionCell {
  @JsonKey(name: 'data')
  final String? title;

  final String? height;

  final String? weight;

  final String? circle;

  @JsonKey(name: 'week')
  final String? week;

  @JsonKey(name: 'notes')
  final String? note;

  EvolutionCell({
    this.title,
    this.height,
    this.weight,
    this.circle,
    this.week,
    this.note,
  });

  factory EvolutionCell.fromJson(Map<String, dynamic> json) =>
      _$EvolutionCellFromJson(json);

  Map<String, dynamic> toJson() => _$EvolutionCellToJson(this);
}
