import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'doctor.g.dart';

class DoctorStore extends _DoctorStore with _$DoctorStore {
  DoctorStore({required super.restClient});
}

abstract class _DoctorStore with Store, BaseStore {
  final RestClient restClient;

  _DoctorStore({required this.restClient});

  @observable
  DoctorModel? doctor;

  @action
  Future fetchAll() async {
    return await fetchData(restClient.get(Endpoint().doctorData), (v) {
      final data = DoctorData.fromJson(v);
      doctor = data.doctor;
      return data;
    });
  }
}
