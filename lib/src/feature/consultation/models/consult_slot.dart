import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'consult_slot.g.dart';

@JsonSerializable()
class ConsultationSlot {
  @JsonKey(name: 'consultation_id')
  final String? id;

  @JsonKey(name: 'consultation_time')
  final String? consultationTime;

  @JsonKey(name: 'consultation_type')
  final ConsultationType type;

  @JsonKey(name: 'patient_full_name')
  final String? fullName;

  ConsultationSlot({
    required this.id,
    required this.consultationTime,
    required this.type,
    required this.fullName,
  });

  DateTime slotTime(DateTime day, bool isStart) {
    // if (consultationTime == null) return DateTime.now();

    final parts = consultationTime!.split('-');
    final timeParts = parts[isStart ? 0 : 1].split(':');
    return DateTime(day.year, day.month, day.day, int.parse(timeParts[0]),
        int.parse(timeParts[1]));
  }

  // DateTime get startTime {
  //   if (consultationTime == null) return DateTime.now();

  //   final parts = consultationTime!.split('-');
  //   final timeParts = parts[0].split(':');
  //   return DateTime(weekday!.year, weekday!.month, weekday!.day,
  //       int.parse(timeParts[0]), int.parse(timeParts[1]));
  // }

  // DateTime get endTime {
  //   if (consultationTime == null) return DateTime.now();

  //   final parts = consultationTime!.split('-');
  //   final timeParts = parts[1].split(':');
  //   return DateTime(weekday!.year, weekday!.month, weekday!.day,
  //       int.parse(timeParts[0]), int.parse(timeParts[1]));
  // }

  factory ConsultationSlot.fromJson(Map<String, dynamic> json) =>
      _$ConsultationSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultationSlotToJson(this);
}
