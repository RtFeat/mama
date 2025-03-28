import 'package:faker_dart/faker_dart.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationViewStore {
  final DoctorsState doctorsState;
  final ConsultationRecordsState recordsState;
  final SchoolsStore schoolsState;

  ConsultationViewStore({
    required ApiClient apiClient,
    required Faker faker,
  })  : recordsState = ConsultationRecordsState(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: params,
          ),
        ),
        doctorsState = DoctorsState(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: params,
          ),
        ),
        schoolsState = SchoolsStore(
            faker: faker,
            apiClient: apiClient,
            fetchFunction: (params, path) => apiClient.get(
                  path,
                  queryParams: params,
                ));

  Future<void> loadAllRecords() async {
    await recordsState.loadPage();
  }

  Future<void> loadAllDoctors() async {
    await doctorsState.loadPage();
  }

  Future<void> loadAllSchools() async {
    await schoolsState.loadPage();
  }
}
