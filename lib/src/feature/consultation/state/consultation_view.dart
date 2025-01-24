import 'package:mama/src/data.dart';

class ConsultationViewStore {
  final DoctorsState doctorsState;
  final ConsultationRecordsState recordsState;
  final SchoolsStore schoolsState;

  ConsultationViewStore({
    required RestClient restClient,
  })  : recordsState = ConsultationRecordsState(
          restClient: restClient,
          fetchFunction: (params, path) => restClient.get(
            path,
            queryParams: params,
          ),
        ),
        doctorsState = DoctorsState(
          restClient: restClient,
          fetchFunction: (params, path) => restClient.get(
            path,
            queryParams: params,
          ),
        ),
        schoolsState = SchoolsStore(
            restClient: restClient,
            fetchFunction: (params, path) => restClient.get(
                  path,
                  queryParams: params,
                ));

  Future<void> loadAllRecords() async {
    await recordsState.loadPage(queryParams: {});
  }

  Future<void> loadAllDoctors() async {
    await doctorsState.loadPage(queryParams: {});
  }

  Future<void> loadAllSchools() async {
    await schoolsState.loadPage(queryParams: {});
  }
}
