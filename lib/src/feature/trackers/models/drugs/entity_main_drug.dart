// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'package:mobx/mobx.dart';

part 'entity_main_drug.g.dart';

@JsonSerializable()
class EntityMainDrug extends _EntityMainDrug with _$EntityMainDrug {
  EntityMainDrug({
    super.dose,
    this.id,
    this.imageId,
    super.imagePath,
    super.isEnd,
    super.name,
    super.notes,
    required super.reminder,
    required super.reminderAfter,
  });
  factory EntityMainDrug.fromJson(Map<String, Object?> json) =>
      _$EntityMainDrugFromJson(json);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'image_id')
  final String? imageId;

  Map<String, Object?> toJson() => _$EntityMainDrugToJson(this);
}

abstract class _EntityMainDrug with Store {
  _EntityMainDrug({
    this.dose,
    this.imagePath,
    this.isEnd,
    this.name,
    this.notes,
    required this.reminder,
    required this.reminderAfter,
  });
  @observable
  String? dose;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? imagePath;

  @observable
  @JsonKey(name: 'isEnd')
  bool? isEnd;

  @action
  void toggleIsEnd() => isEnd = !isEnd!;

  @observable
  @JsonKey(name: 'name')
  String? name;

  @observable
  @JsonKey(name: 'notes')
  String? notes;

  @observable
  @JsonKey(name: 'reminder', fromJson: _listFromJson, toJson: _listToJson)
  ObservableList reminder = ObservableList();

  @observable
  @JsonKey(name: 'reminder_after', fromJson: _listFromJson, toJson: _listToJson)
  ObservableList reminderAfter = ObservableList();

  static List _listToJson(v) {
    return v.toList();
  }

  static ObservableList _listFromJson(List? v) {
    final data = v?.map((e) => e).toList();
    return ObservableList.of(data ?? []);
  }
}
