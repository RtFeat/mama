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
  _DoctorStore({required RestClient restClient})
      : super(
          fetchFunction: () => restClient.get(Endpoint().doctorData),
          transformer: (v) {
            if (v == null) return DoctorData();
            return DoctorData.fromJson(v);
          },
        );

  @computed
  List<WorkSlot> get slots =>
      // [
      //       WorkSlot(
      //         isBusy: false,
      //         workSlot: '9:00 - 10:00',
      //         consultationType: 'sdf',
      //         patientFullName: 'dsfsdf sdf s',
      //       ),
      //       WorkSlot(
      //         isBusy: false,
      //         workSlot: '11:00 - 13:00',
      //         consultationType: 'type1',
      //         patientFullName: 'John Doe',
      //       ),
      //       WorkSlot(
      //         isBusy: true,
      //         workSlot: '13:00 - 14:00',
      //         consultationType: 'type2',
      //         patientFullName: 'Jane Smith',
      //       ),
      //       WorkSlot(
      //         isBusy: true,
      //         workSlot: '21:00 - 22:00',
      //         consultationType: 'type2',
      //         patientFullName: 'Jane Smith',
      //       ),
      //     ];
      data?.doctor?.workTime?.slots ?? [];

  @computed
  List<List<WorkSlot>> get weekSlots => [
        data?.doctor?.workTime?.monday?.workSlots ?? [],
        data?.doctor?.workTime?.tuesday?.workSlots ?? [],
        data?.doctor?.workTime?.wednesday?.workSlots ?? [],
        data?.doctor?.workTime?.thursday?.workSlots ?? [],
        data?.doctor?.workTime?.friday?.workSlots ?? [],
        data?.doctor?.workTime?.saturday?.workSlots ?? [],
        data?.doctor?.workTime?.sunday?.workSlots ?? [],
      ];

  @computed
  List<List<WorkSlot>> get dividedSlots {
    final now = DateTime.now();
    List<WorkSlot> beforeNow = [];
    List<WorkSlot> afterNow = [];

    for (var slot in slots) {
      if (slot.startTime.isBefore(now)) {
        beforeNow.add(slot);
      } else {
        afterNow.add(slot);
      }
    }

    return [beforeNow, afterNow];
  }
}
