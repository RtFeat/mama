import 'package:json_annotation/json_annotation.dart';

part 'child_status.g.dart';

enum ChildStatusType {
  @JsonValue('Лекарство!')
  drug,
  @JsonValue('Скоро делать прививку!')
  vaccination,
  @JsonValue('Все хорошо')
  good,
  @JsonValue('Рождение')
  birth,
  @JsonValue('')
  nothing,
}

@JsonSerializable()
class ChildStatus {
  @JsonKey(name: 'body')
  final String title;

  final ChildStatusType? value;

  const ChildStatus({required this.title, required this.value});

  factory ChildStatus.fromJson(Map<String, dynamic> json) =>
      _$ChildStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ChildStatusToJson(this);
}
