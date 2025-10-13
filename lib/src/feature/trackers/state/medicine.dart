import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'medicine.g.dart';

class MedicineStore extends _MedicineStore with _$MedicineStore {
  MedicineStore({
    required super.restClient,
    required super.userStore,
  });
}

abstract class _MedicineStore with Store {
  _MedicineStore({required this.restClient, required this.userStore}) {
    _setupChildIdReaction();
  }

  final ApiClient restClient;
  final UserStore userStore;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

  @observable
  bool _isActive = true;

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

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          print('MedicineStore reaction: childId changed to $newChildId');
          
          // Очищаем старые данные
          runInAction(() {
            drugModel = null;
          });
          
          // Загружаем новые данные для нового ребенка
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    print('MedicineStore _loadDataForChild: Loading for childId: $childId');
    
    // Здесь можно добавить логику загрузки данных для конкретного ребенка
    // Например, загрузить список лекарств для этого ребенка
    _refreshDataForChild(childId);
  }

  @action
  void _refreshDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    print('MedicineStore _refreshDataForChild: Refreshing data for childId: $childId');
    
    // Очищаем текущие данные
    runInAction(() {
      drugModel = null;
    });
    
    // Загружаем данные для нового ребенка
    _loadMedicineDataForChild(childId);
  }

  @action
  void _loadMedicineDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    print('MedicineStore _loadMedicineDataForChild: Loading medicine data for childId: $childId');
    
    // Здесь можно добавить API вызов для загрузки списка лекарств для конкретного ребенка
    // Например: restClient.get('medicine/$childId') или подобное
    // Пока что просто очищаем данные, чтобы показать, что данные обновились
    runInAction(() {
      drugModel = null;
    });
  }

  @action
  void deactivate() {
    _isActive = false;
    _childIdReaction?.call();
    _childIdReaction = null;
  }

  @action
  void activate() {
    _isActive = true;
    if (_childIdReaction == null) {
      _setupChildIdReaction();
    }
    // Загружаем данные при активации только если есть childId
    if (childId.isNotEmpty) {
      _loadDataForChild(childId);
    }
  }

  @action
  void postData({required DrugModel model}) {
    restClient.post(Endpoint.medicine, body: model.toJson()).then(
      (value) {
        return print('Drug was successfully added');
      },
    );
  }
}
