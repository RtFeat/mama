import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'filter.g.dart';

class KnowledgeFilter extends _KnowledgeFilter with _$KnowledgeFilter {
  final Function() onTap;
  final String title;
  final bool isSelected;
  KnowledgeFilter({
    required this.onTap,
    required this.title,
    this.isSelected = false,
  });
}

abstract class _KnowledgeFilter with Store {}

@JsonSerializable()
class KnowledgeFilterModel extends _KnowledgeFilterModel
    with _$KnowledgeFilterModel {
  KnowledgeFilterModel();

  factory KnowledgeFilterModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeFilterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KnowledgeFilterModelToJson(this);
}

abstract class _KnowledgeFilterModel extends SkitBaseModel with Store {
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected = false;

  @action
  void setSelected(bool value) => isSelected = value;
}
