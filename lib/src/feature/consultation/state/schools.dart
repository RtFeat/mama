// import 'package:mama/src/data.dart';
// import 'package:mobx/mobx.dart';

// part 'schools.g.dart';

// class SchoolsStore extends _SchoolsStore with _$SchoolsStore {
//   SchoolsStore({
//     required super.restClient,
//   });
// }

// abstract class _SchoolsStore with Store, LoadingDataStoreExtension {
//   final RestClient restClient;

//   _SchoolsStore({required this.restClient});

//   Future loadData() async {
//     return await fetchData(restClient.get(Endpoint().schools), (v) {
//       final data = Schools.fromJson(v);
//       listData = ObservableList.of(data.schools ?? []);
//       return data;
//     });
//   }
// }

import 'package:mama/src/data.dart';

class SchoolsStore extends PaginatedListStore {
  SchoolsStore({
    required super.fetchFunction,
  }) : super(
          transformer: (raw) {
            final data = Schools.fromJson(raw);
            return data.schools ?? [];
          },
        );
}
