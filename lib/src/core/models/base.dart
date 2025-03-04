import 'package:json_annotation/json_annotation.dart';
import 'package:skit/skit.dart';

part 'base.g.dart';

@JsonSerializable()
class BaseModel extends SkitBaseModel {
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  BaseModel({this.updatedAt, this.createdAt});

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}
