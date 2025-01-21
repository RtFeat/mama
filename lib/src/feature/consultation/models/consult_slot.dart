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

  @JsonKey(includeToJson: false, includeFromJson: false)
  final DateTime? dateTime;

  ConsultationSlot({
    required this.id,
    required this.consultationTime,
    required this.type,
    required this.fullName,
    this.dateTime,
  });

  DateTime slotTime(DateTime day, bool isStart) {
    // Получаем части времени из consultationTime
    final parts = consultationTime!.split('-');
    final timeParts = parts[isStart ? 0 : 1].split(':');

    // Создаём объект DateTime с учётом UTC
    DateTime utcTime = DateTime.utc(day.year, day.month, day.day,
        int.parse(timeParts[0]), int.parse(timeParts[1]));

    // Переводим его в локальное время
    return utcTime.toLocal();
  }

  String get time {
    final now = DateTime.now().toLocal();
    final start = slotTime(now, true);
    final end = slotTime(now, false);

    return start.timeRange(end);
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

  ConsultationSlot copyWith({
    String? id,
    String? consultationTime,
    ConsultationType? type,
    String? fullName,
    DateTime? dateTime,
  }) {
    return ConsultationSlot(
      id: id ?? this.id,
      consultationTime: consultationTime ?? this.consultationTime,
      type: type ?? this.type,
      fullName: fullName ?? this.fullName,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory ConsultationSlot.fromJson(Map<String, dynamic> json) =>
      _$ConsultationSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultationSlotToJson(this);
}
