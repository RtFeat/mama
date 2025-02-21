import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:mama/src/data.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel extends _CategoryModel with _$CategoryModel {
  final String id;
  @JsonKey(name: 'name')
  final String title;

  @JsonKey(name: 'quantity')
  final int? count;

  CategoryModel({
    required this.id,
    required this.title,
    this.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

abstract class _CategoryModel extends KnowledgeFilterModel with Store {}
