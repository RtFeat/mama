import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'consultation.g.dart';

enum ConsultationType {
  @JsonValue('CHAT')
  chat,
  @JsonValue('VIDEO')
  video,
  @JsonValue('EXPRESS')
  express,
}

enum ConsultationStatus {
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('PENDING')
  pending,
}

// @JsonSerializable()
// class Consultation extends BaseModel {
//   final String? id;

//   final DoctorModel? doctor;

//   @JsonKey(name: 'account')
//   final AccountModel? patient;

//   final ConsultationType type;

//   ConsultationStatus status;

//   final String? comment;

//   @JsonKey(name: 'time_begin')
//   final DateTime? startedAt;

//   @JsonKey(name: 'time_end')
//   final DateTime? endedAt;

//   Consultation({
//     this.id,
//     this.patient,
//     this.doctor,
//     this.type = ConsultationType.chat,
//     this.status = ConsultationStatus.pending,
//     this.startedAt,
//     this.comment,
//     super.updatedAt,
//     super.createdAt,
//     this.endedAt,
//   });

//   factory Consultation.fromJson(Map<String, dynamic> json) =>
//       _$ConsultationFromJson(json);

//   Map<String, dynamic> toJson() => _$ConsultationToJson(this);
// }

@JsonSerializable()
class Consultation extends _Consultation with _$Consultation {
  final String? id;

  final DoctorModel? doctor;

  @JsonKey(name: 'account')
  final AccountModel? patient;

  final ConsultationType type;

  // ConsultationStatus status;

  final String? comment;

  @JsonKey(name: 'time_begin')
  final DateTime? startedAt;

  @JsonKey(name: 'time_end')
  final DateTime? endedAt;

  Consultation({
    this.id,
    this.patient,
    this.doctor,
    this.type = ConsultationType.chat,
    // this.status = ConsultationStatus.pending,
    this.startedAt,
    this.comment,
    this.endedAt,
    super.status = ConsultationStatus.pending,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationToJson(this);
}

abstract class _Consultation with Store {
  _Consultation({
    required this.status,
  });

  @observable
  ConsultationStatus status = ConsultationStatus.pending;
}
