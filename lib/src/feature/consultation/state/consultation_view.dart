import 'package:mama/src/data.dart';

class ConsultationViewStore {
  final DoctorsState doctorsState;
  final ConsultationRecordsState recordsState;
  final SchoolsStore schoolsState;

  ConsultationViewStore({
    required RestClient restClient,
  })  : recordsState = ConsultationRecordsState(
          fetchFunction: (params) => restClient.get(
            Endpoint().userConsultations,
            queryParams: params,
          ),
        ),
        doctorsState = DoctorsState(
          fetchFunction: (params) => restClient.get(
            Endpoint.doctor,
            queryParams: params,
          ),
        ),
        schoolsState = SchoolsStore(
            fetchFunction: (params) => restClient.get(
                  Endpoint().schools,
                  queryParams: params,
                ));

  Future<void> loadAllRecords() async {
    await recordsState.loadPage(queryParams: {'page_size': '10'});
  }

  Future<void> loadAllDoctors() async {
    await doctorsState.loadPage(queryParams: {'page_size': '10'});
  }

  Future<void> loadAllSchools() async {
    await schoolsState.loadPage(queryParams: {'page_size': '10'});
  }
}
