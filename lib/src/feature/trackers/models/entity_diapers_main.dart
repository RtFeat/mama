import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'entity_diapers_sub_main.dart';

part 'entity_diapers_main.g.dart';

@JsonSerializable()
class DiapersMain extends _DiapersMain with _$DiapersMain {
  @JsonKey(name: 'diapers_sub')
  final List<DiapersSubMain>? diapersSub;

  @JsonKey(name: 'data')
  final String? data;

  DiapersMain({
    this.diapersSub,
    this.data,
  });
  factory DiapersMain.fromJson(Map<String, dynamic> json) =>
      _$DiapersMainFromJson(json);
  Map<String, dynamic> toJson() => _$DiapersMainToJson(this);
}

abstract class _DiapersMain with Store {}
