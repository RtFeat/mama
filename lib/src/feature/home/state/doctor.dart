// import 'package:mama/src/data.dart';
// import 'package:mobx/mobx.dart';

// part 'doctor.g.dart';

// class DoctorStore extends _DoctorStore with _$DoctorStore {
//   DoctorStore({required super.restClient});
// }

// abstract class _DoctorStore with Store, LoadingDataStoreExtension {
//   final RestClient restClient;

//   _DoctorStore({required this.restClient});

//   @observable
//   DoctorModel? doctor;

//   @action
//   Future fetchAll() async {
//     return await fetchData(restClient.get(Endpoint().doctorData), (v) {
//       final data = DoctorData.fromJson(v);
//       doctor = data.doctor;
//       return data;
//     });
//   }
// }

// import 'package:mama/src/data.dart';

// class DoctorStore extends SingleDataStore {
//   DoctorStore({required RestClient restClient})
//       : super(
//           fetchFunction: () => restClient.get(Endpoint().doctorData),
//           transformer: (v) {
//             if (v == null) return null;
//             return DoctorData.fromJson(v);
//           },
//         );
// }

import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'doctor.g.dart';

class DoctorStore extends _DoctorStore with _$DoctorStore {
  DoctorStore({
    required super.restClient,
  });
}

abstract class _DoctorStore extends SingleDataStore<DoctorData> with Store {
  final RestClient restClient;
  _DoctorStore({required this.restClient})
      : super(
          fetchFunction: (_) => restClient.get(Endpoint().doctorData),
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
  List<List<ConsultationSlot>> get weekConsultations => [
        data?.doctor?.workTime?.monday?.consultations ?? [],
        data?.doctor?.workTime?.tuesday?.consultations ?? [],
        data?.doctor?.workTime?.wednesday?.consultations ?? [],
        data?.doctor?.workTime?.thursday?.consultations ?? [],
        data?.doctor?.workTime?.friday?.consultations ?? [],
        data?.doctor?.workTime?.saturday?.consultations ?? [],
        data?.doctor?.workTime?.sunday?.consultations ?? [],
      ];

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
  DateTime get weekStart => data?.doctor?.workTime?.weekStart ?? DateTime.now();

  @observable
  int selectedDay = DateTime.now().weekday;

  @action
  setSelectedDay(int value) => selectedDay = value;

  @computed
  ObservableList<List<ConsultationSlot>> get dividedSlots {
    logger.info('Week consultations: $weekConsultations');
    final now = DateTime.now();
    List<ConsultationSlot> beforeNow = [];
    List<ConsultationSlot> afterNow = [];

    for (var slot in weekConsultations[selectedDay - 1]) {
      if (slot.slotTime(weekStart, true).isBefore(now)) {
        beforeNow.add(slot);
      } else {
        afterNow.add(slot);
      }
    }

    logger.info('${[beforeNow, afterNow]}');

    return ObservableList.of([beforeNow, afterNow]);
  }

  @action
  void setDayHoliday({required DateTime day}) {
    restClient.post(Endpoint().doctorHoliday, body: {
      'date': day.toUtc().toIso8601String(),
    }).then((v) {
      data?.doctor?.workTime?.updateConsultations(day.weekday, []);
    });
  }

  @action
  void cancelConsultations({required DateTime day}) {
    restClient.post(Endpoint().doctorCancelConsultations, body: {
      'date': day.toUtc().toIso8601String(),
    }).then((v) {
      data?.doctor?.workTime?.updateConsultations(day.weekday, []);
    });
  }
}
