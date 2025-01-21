import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel extends _CategoryModel with _$CategoryModel {
  final String id;
  @JsonKey(name: 'name')
  final String title;
  CategoryModel({
    required this.id,
    required this.title,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

abstract class _CategoryModel with Store {
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected = false;

  @action
  void setSelected(bool value) => isSelected = value;
}
