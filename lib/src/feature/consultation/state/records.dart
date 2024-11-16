// import 'package:mama/src/data.dart';
// import 'package:mobx/mobx.dart';

// part 'records.g.dart';

// class ConsultationRecordsStore extends _ConsultationRecordsStore
//     with _$ConsultationRecordsStore {
//   ConsultationRecordsStore({
//     required super.restClient,
//   });
// }

// abstract class _ConsultationRecordsStore
//     with Store, LoadingDataStoreExtension<Consultations> {
//   final RestClient restClient;

//   _ConsultationRecordsStore({
//     required this.restClient,
//   });

//   Future fetchUserConsultations() async {
//     return await fetchData(restClient.get(Endpoint().userConsultations), (v) {
//       final data = Consultations.fromJson(v);
//       listData = ObservableList.of(data.data ?? []);
//       return data;
//     });
//   }
// }

import 'package:mama/src/data.dart';

class ConsultationRecordsState extends PaginatedListStore {
  ConsultationRecordsState({
    required super.fetchFunction,
  }) : super(
          transformer: (raw) {
            final data = Consultations.fromJson(raw);
            return data.data ?? [];
          },
        );
}
