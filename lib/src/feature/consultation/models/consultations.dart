import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

part 'consultations.g.dart';

@JsonSerializable()
class Consultations extends SkitBaseModel {
  @JsonKey(name: 'consultations')
  final List<Consultation>? data;

  Consultations({this.data});

  factory Consultations.fromJson(Map<String, dynamic> json) =>
      _$ConsultationsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConsultationsToJson(this);
}
