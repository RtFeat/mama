import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'temperature_model.g.dart';

@JsonSerializable()
class TemperatureModel extends _TemperatureModel with _$TemperatureModel {
  TemperatureModel(
      {required super.childId,
      required super.isBad,
      required super.notes,
      required super.temperature,
      required super.time});

  factory TemperatureModel.fromJson(Map<String, dynamic> json) =>
      _$TemperatureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemperatureModelToJson(this);
}

abstract class _TemperatureModel with Store {
  _TemperatureModel({
    this.childId,
    this.isBad,
    this.notes,
    this.temperature,
    this.time,
  });

  @observable
  @JsonKey(name: 'child_id')
  String? childId;

  @observable
  @JsonKey(name: 'is_bad')
  String? isBad;

  @observable
  @JsonKey(name: 'notes')
  String? notes;

  @observable
  @JsonKey(name: 'temperature')
  String? temperature;

  @observable
  @JsonKey(name: 'time')
  String? time;
}
