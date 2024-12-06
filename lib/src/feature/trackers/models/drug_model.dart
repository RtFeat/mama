import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'drug_model.g.dart';

@JsonSerializable()
class DrugModel extends _DrugModel with _$DrugModel {
  DrugModel({
    required super.childId,
    required super.dataStart,
    super.photo,
    super.nameDrug,
    super.dose,
    super.comment,
    super.isEnd,
    super.reminder,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) =>
      _$DrugModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrugModelToJson(this);
}

abstract class _DrugModel with Store {
  _DrugModel({
    required this.childId,
    required this.dataStart,
    this.photo,
    this.nameDrug,
    this.dose,
    this.comment,
    this.isEnd,
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
  @JsonKey(name: 'childId')
  String childId;

  @action
  setChildId(String value) {
    childId = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'nameDrug')
  String? nameDrug;

  @action
  setNameDrug(String? value) {
    nameDrug = value;
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
  @JsonKey(name: 'comment')
  String? comment;

  @action
  setComment(String? value) {
    comment = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'dataStart')
  String dataStart;

  @action
  setDataStart(String value) {
    dataStart = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'is_end')
  bool? isEnd;

  @action
  setIsEnd(bool? value) {
    isEnd = value;
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
