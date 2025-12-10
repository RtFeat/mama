import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'entity_diapers_sub_main.g.dart';

@JsonEnum()
enum TypeOfDiapers {
  @JsonValue('Смешанный')
  mixed,
  @JsonValue('Мокрый')
  wet,
  @JsonValue('Грязный')
  dirty,
}

@JsonSerializable()
class DiapersSubMain extends _DiapersSubMain with _$DiapersSubMain {
  @JsonKey(name: 'data')
  final String? data;

  @JsonKey(name: 'how_much')
  final String? howMuch;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'type_of_diapers')
  final TypeOfDiapers? typeOfDiapers;

  DiapersSubMain({
    this.data,
    this.howMuch,
    this.notes,
    this.typeOfDiapers,
  });
  factory DiapersSubMain.fromJson(Map<String, dynamic> json) =>
      _$DiapersSubMainFromJson(json);
  Map<String, dynamic> toJson() => _$DiapersSubMainToJson(this);
}

abstract class _DiapersSubMain with Store {}
