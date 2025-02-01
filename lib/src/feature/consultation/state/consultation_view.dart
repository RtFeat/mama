import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationViewStore {
  final DoctorsState doctorsState;
  final ConsultationRecordsState recordsState;
  final SchoolsStore schoolsState;

  ConsultationViewStore({
    required ApiClient apiClient,
  })  : recordsState = ConsultationRecordsState(
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: params,
          ),
        ),
        doctorsState = DoctorsState(
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: params,
          ),
        ),
        schoolsState = SchoolsStore(
            apiClient: apiClient,
            fetchFunction: (params, path) => apiClient.get(
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
