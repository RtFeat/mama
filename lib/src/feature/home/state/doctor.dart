import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'doctor.g.dart';

class DoctorStore extends _DoctorStore with _$DoctorStore {
  DoctorStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _DoctorStore extends SingleDataStore<DoctorData> with Store {
  _DoctorStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return DoctorData(
              doctor: DoctorModel.mock(faker),
            );
          },
          fetchFunction: (_) => apiClient.get(Endpoint().doctorData),
          transformer: (v) {
            if (v == null) return DoctorData();
            return DoctorData.fromJson(v);
          },
        );

  @computed
  ObservableList<WorkSlot> get slots =>
      data?.doctor?.workTime?.slots ?? ObservableList();

  ObservableList<WorkSlot> slotsByDay(int weekDay) =>
      data?.doctor?.workTime?.slotByDay(weekDay) ?? ObservableList();

  @computed
  List<List<ConsultationSlot>> get weekConsultations {
    if (data?.doctor?.workTime == null) {
      return List.generate(7, (_) => <ConsultationSlot>[]);
    }

    final weekStart = data!.doctor!.workTime!.weekStart!;
    final adjustedConsultations = List.generate(7, (_) => <ConsultationSlot>[]);

    for (int i = 0; i < 7; i++) {
      final List<ConsultationSlot> dayConsultations =
          data!.doctor!.workTime!.consultationByDay(i + 1) ?? [];
      final currentDay = weekStart.add(Duration(days: i));

      for (final consultation in dayConsultations) {
        final localTime = consultation.slotTime(currentDay, true);
        logger.info(
            'Consultation ID: ${consultation.id}, Local Time: $localTime, Weekday: ${localTime.weekday}');
        adjustedConsultations[localTime.weekday - 1].add(consultation.copyWith(
          dateTime: localTime,
        ));
      }

      // Сортируем консультации в пределах дня
      adjustedConsultations[i].sort((a, b) {
        // final timeA = a.slotTime(currentDay, true);
        // final timeB = b.slotTime(currentDay, true);

        return a.dateTime!.compareTo(b.dateTime!);
        //  ??
        // timeA.compareTo(timeB);
      });
    }

    return adjustedConsultations;
  }

  @computed
  List<ObservableList<WorkSlot>> get weekSlots => [
        data?.doctor?.workTime?.monday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.tuesday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.wednesday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.thursday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.friday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.saturday?.workSlots ?? ObservableList(),
        data?.doctor?.workTime?.sunday?.workSlots ?? ObservableList(),
      ];

  @computed
  DateTime get weekStart =>
      data?.doctor?.workTime?.weekStart?.toLocal() ?? DateTime.now();

  @observable
  int selectedDay = DateTime.now().weekday;

  @action
  setSelectedDay(int value) => selectedDay = value;

  @computed
  ObservableList<List<ConsultationSlot>> get dividedSlots {
    final now = DateTime.now();
    List<ConsultationSlot> beforeNow = [];
    List<ConsultationSlot> afterNow = [];

    final ObservableList<ConsultationSlot> data =
        ObservableList.of(weekConsultations[selectedDay - 1]);

    for (var slot in data) {
      final slotTime =
          slot.slotTime(weekStart.add(Duration(days: selectedDay - 1)), true);
      if (slotTime.isBefore(now)) {
        beforeNow.add(slot);
      } else {
        afterNow.add(slot);
      }
    }

    return ObservableList.of([beforeNow, afterNow]);
  }

  @action
  void setDayHoliday({required DateTime day}) {
    apiClient.post(Endpoint().doctorHoliday, body: {
      'date': day.toUtc().toIso8601String(),
    }).then((v) {
      data?.doctor?.workTime?.updateConsultations(day.weekday, []);
    });
  }

  @action
  void cancelConsultations({required DateTime day}) {
    apiClient.post(Endpoint().doctorCancelConsultations, body: {
      'date': day.toUtc().toIso8601String(),
    }).then((v) {
      data?.doctor?.workTime?.updateConsultations(day.weekday, []);
    });
  }
}
