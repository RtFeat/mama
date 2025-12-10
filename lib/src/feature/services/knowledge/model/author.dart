import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'author.g.dart';

@JsonSerializable()
class AuthorModel extends _AuthorModel with _$AuthorModel {
  @JsonKey(name: 'counter')
  final int? count;

  final WriterModel? writer;

  AuthorModel({
    required this.count,
    required this.writer,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}

abstract class _AuthorModel extends KnowledgeFilterModel with Store {}

@JsonSerializable(fieldRename: FieldRename.snake)
class WriterModel extends SkitBaseModel {
  final String? accountId;

  final String? firstName;
  final String? lastName;

  String get fullName => '$firstName ${lastName ?? ''}';

  final String? photoId;

  @JsonKey(name: 'doctor_profession')
  final String? profession;

  final Role? role;

  WriterModel({
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.photoId,
    required this.profession,
    required this.role,
  });

  factory WriterModel.fromJson(Map<String, dynamic> json) =>
      _$WriterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WriterModelToJson(this);
}
