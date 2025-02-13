import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'doctor_visit.g.dart';

class DoctorVisitStore extends _DoctorVisitStore with _$DoctorVisitStore {
  DoctorVisitStore({
    required super.restClient,
  });
}

abstract class _DoctorVisitStore with Store {
  _DoctorVisitStore({required this.restClient});

  final RestClient restClient;

  @observable
  DoctorVisitModel? doctorVisitModel;

  @computed
  DoctorVisitModel get doctorVisit =>
      doctorVisitModel ??
      DoctorVisitModel(
        child_id: '',
        data_start: '',
        clinic: '',
        doctor: '',
        notes: '',
        photo: '',
      );

  @action
  void postData({required DoctorVisitModel model}) {
    restClient.post('${Endpoint.doctorVisit}', body: model.toJson()).then(
      (value) {
        return print('Doctor Visit was successfully added');
      },
    );
  }
}
