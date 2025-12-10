// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'doctor_visit_model.g.dart';

@JsonSerializable()
class DoctorVisitModel extends _DoctorVisitModel with _$DoctorVisitModel {
  DoctorVisitModel({
    required super.child_id,
    required super.data_start,
    super.photo,
    super.doctor,
    super.clinic,
    super.notes,
  });

  factory DoctorVisitModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorVisitModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorVisitModelToJson(this);
}

abstract class _DoctorVisitModel with Store {
  _DoctorVisitModel({
    required this.child_id,
    required this.data_start,
    this.photo,
    this.doctor,
    this.clinic,
    this.notes,
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
  @JsonKey(name: 'doctor')
  String? doctor;

  @action
  setDoctor(String? value) {
    doctor = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'clinic')
  String? clinic;

  @action
  setClinic(String? value) {
    clinic = value;
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
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isChanged = false;

  @action
  void setIsChanged(bool value) {
    isChanged = value;
  }
}
