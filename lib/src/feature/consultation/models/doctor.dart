import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'doctor.g.dart';

@JsonSerializable()
class DoctorModel extends BaseModel {
  final String? id;

  @JsonKey(name: 'account_id')
  final String? accountId;

  final AccountModel? account;

  @JsonKey(name: 'is_consultation')
  final bool isConsultation;

  @JsonKey(name: 'profession')
  final String? profession;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'time_work')
  final DoctorWorkTime? workTime;

  @JsonKey(name: 'count_articles')
  final int? countArticles;

  String get fullName =>
      '$firstName ${lastName != null && lastName!.isNotEmpty ? lastName : ''}';

  DoctorModel({
    this.id,
    this.account,
    this.accountId,
    this.isConsultation = false,
    this.profession,
    super.updatedAt,
    this.countArticles,
    this.firstName,
    this.lastName,
    super.createdAt,
    this.workTime,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
