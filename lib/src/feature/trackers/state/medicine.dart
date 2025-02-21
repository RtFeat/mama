import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'medicine.g.dart';

class MedicineStore extends _MedicineStore with _$MedicineStore {
  MedicineStore({
    required super.restClient,
  });
}

abstract class _MedicineStore with Store {
  _MedicineStore({required this.restClient});

  final RestClient restClient;

  // @observable
  // ObservableFuture<DrugModel> fetchMedicineFuture = emptyResponse;

  @observable
  DrugModel? drugModel;

  @computed
  DrugModel get drug =>
      drugModel ??
      DrugModel(
        child_id: '',
        data_start: '',
        dose: '',
        name_drug: '',
        notes: '',
        is_end: false,
        photo: '',
        reminder: '',
      );

  @action
  void postData({required DrugModel model}) {
    restClient.post(Endpoint.medicine, body: model.toJson()).then(
      (value) {
        return print('Drug was successfully added');
      },
    );
  }
}
