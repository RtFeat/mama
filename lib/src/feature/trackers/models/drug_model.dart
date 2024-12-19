// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'drug_model.g.dart';

@JsonSerializable()
class DrugModel extends _DrugModel with _$DrugModel {
  DrugModel({
    required super.child_id,
    required super.data_start,
    super.photo,
    super.name_drug,
    super.dose,
    super.notes,
    super.is_end,
    super.reminder,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) =>
      _$DrugModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrugModelToJson(this);
}

abstract class _DrugModel with Store {
  _DrugModel({
    required this.child_id,
    required this.data_start,
    this.photo,
    this.name_drug,
    this.dose,
    this.notes,
    this.is_end,
    this.reminder,
  });

  @observable
  @JsonKey(name: 'photo')
  String? photo;

  @action
  setPhoto(String? value) {
    photo = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'child_id')
  String child_id;

  @action
  setChildId(String value) {
    child_id = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'name_drug')
  String? name_drug;

  @action
  setNameDrug(String? value) {
    name_drug = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'dose')
  String? dose;

  @action
  setDose(String? value) {
    dose = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'notes')
  String? notes;

  @action
  setComment(String? value) {
    notes = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'data_start')
  String data_start;

  @action
  setDataStart(String value) {
    data_start = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'is_end')
  bool? is_end;

  @action
  setIsEnd(bool? value) {
    is_end = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'reminder')
  String? reminder;

  @action
  setReminder(String? value) {
    reminder = value;
    isChanged = true;
  }

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isChanged = false;

  @action
  void setIsChanged(bool value) {
    isChanged = value;
  }
}
