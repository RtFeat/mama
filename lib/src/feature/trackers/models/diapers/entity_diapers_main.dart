// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

import 'entity_diapers_sub_main.dart';

part 'entity_diapers_main.g.dart';

@JsonSerializable()
class EntityDiapersMain extends _EntityDiapersMain with _$EntityDiapersMain {
  EntityDiapersMain({
    required super.data,
    required super.diapersSub,
  });

  factory EntityDiapersMain.fromJson(Map<String, dynamic> json) =>
      _$EntityDiapersMainFromJson(json);
}

abstract class _EntityDiapersMain with Store {
  _EntityDiapersMain({
    this.data,
    this.diapersSub,
  });

  @observable
  String? data;

  @JsonKey(
      name: 'diapers_sub', fromJson: _diapersFromJson, toJson: _diapersToJson)
  @observable
  ObservableList<EntityDiapersSubMain>? diapersSub;

  static List<EntityDiapersSubMain> _diapersToJson(v) {
    return v.toList();
  }

  static ObservableList<EntityDiapersSubMain> _diapersFromJson(List? v) {
    final workSlots = v?.map((e) => EntityDiapersSubMain.fromJson(e)).toList();
    return ObservableList.of(workSlots ?? []);
  }
}
