import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

@JsonSerializable()
class BaseModel {
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  BaseModel({this.updatedAt, this.createdAt});

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}
