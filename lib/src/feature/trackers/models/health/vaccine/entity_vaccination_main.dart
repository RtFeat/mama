// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'entity_vaccination_main.g.dart';

@JsonSerializable()
class EntityVaccinationMain extends _EntityVaccinationMain
    with _$EntityVaccinationMain {
  EntityVaccinationMain({
    this.age,
    this.ageDescription,
    this.id,
    super.mark,
    super.markDescription,
    this.name,
    this.clinic,
    this.notes,
    this.photo,
    this.date,
  });

  factory EntityVaccinationMain.fromJson(Map<String, Object?> json) =>
      _$EntityVaccinationMainFromJson(json);

  final String? age;
  @JsonKey(name: 'age_description')
  final String? ageDescription;
  final String? clinic;
  final String? id;
  final String? name;
  final String? notes;
  final String? photo;
  @JsonKey(name: 'time_vaccination')
  final DateTime? date;

  Map<String, Object?> toJson() => _$EntityVaccinationMainToJson(this);
}

abstract class _EntityVaccinationMain with Store {
  _EntityVaccinationMain({
    this.mark,
    this.markDescription,
  });
  @observable
  String? mark;

  @action
  void setMark(String value) => mark = value;

  @observable
  String? markDescription;

  @action
  void setMarkDescription(String value) => markDescription = value;
}
