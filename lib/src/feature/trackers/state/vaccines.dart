import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'vaccines.g.dart';

class VaccinesStore extends _VaccinesStore with _$VaccinesStore {
  VaccinesStore({
    required super.restClient,
  });
}

abstract class _VaccinesStore with Store {
  _VaccinesStore({required this.restClient});

  final ApiClient restClient;

  @observable
  VaccineModel? vaccineModel;

  @computed
  VaccineModel get vaccine =>
      vaccineModel ??
      VaccineModel(
        child_id: '',
        data_start: '',
        clinic: '',
        vaccination: '',
        notes: '',
        photo: '',
      );

  @action
  void postData({required DoctorVisitModel model}) {
    restClient.post(Endpoint.vaccine, body: model.toJson()).then(
      (value) {
        return print('Vaccine was successfully added');
      },
    );
  }
}
