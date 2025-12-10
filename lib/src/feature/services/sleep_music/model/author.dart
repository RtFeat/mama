import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class MusicAuthorModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  MusicAuthorModel({
    required this.id,
    required this.name,
  });

  factory MusicAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$MusicAuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusicAuthorModelToJson(this);
}
