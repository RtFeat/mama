import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'age.g.dart';

@JsonSerializable()
class AgeCategoryModel extends CategoryModel {
  AgeCategoryModel({
    required super.id,
    required super.title,
    super.count,
  });

  String get localizedTitle {
    final Map<String, AgeCategory> ageCategoryMap = {
      'from0to0.5': AgeCategory.halfYear,
      'from0.5to1': AgeCategory.year,
      'from1to2': AgeCategory.twoYear,
      'from2to': AgeCategory.older,
    };

    final ageCategory = ageCategoryMap[title];

    if (ageCategory == null) return '';

    return switch (ageCategory) {
      AgeCategory.halfYear => t.home.ageCategory.halfYear,
      AgeCategory.year => t.home.ageCategory.year,
      AgeCategory.twoYear => t.home.ageCategory.twoYear,
      AgeCategory.older => t.home.ageCategory.older,
    };
  }

  @override
  Map<String, dynamic> toJson() => _$AgeCategoryModelToJson(this);

  factory AgeCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AgeCategoryModelFromJson(json);
}
