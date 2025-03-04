import 'package:faker_dart/faker_dart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'school.g.dart';

@JsonSerializable()
class SchoolModel extends BaseModel {
  final String? id;

  final AccountModel? account;

  @JsonKey(name: 'name')
  final String? title;

  @JsonKey(name: 'course')
  final bool isCourse;

  @JsonKey(name: 'article_number')
  final int? articlesCount;

  SchoolModel({
    required this.id,
    required this.account,
    required this.title,
    this.isCourse = false,
    required this.articlesCount,
  });

  factory SchoolModel.mock(Faker faker) {
    return SchoolModel(
        id: faker.datatype.uuid(),
        account: AccountModel.mock(faker),
        isCourse: false,
        title: faker.lorem.word(),
        articlesCount: faker.datatype.number());
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SchoolModelToJson(this);
}
