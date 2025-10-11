import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_growth.g.dart';

enum GrowthUnit { cm, m }

class AddGrowthViewStore extends _AddGrowthViewStore with _$AddGrowthViewStore {
  AddGrowthViewStore({
    required super.restClient,
    // required super.store,
  });
}

abstract class _AddGrowthViewStore with Store {
  final RestClient restClient;

  _AddGrowthViewStore({
    required this.restClient,
  });

  @observable
  DateTime? selectedDate = DateTime.now();

  @action
  void updateDateTime(DateTime? dateTime) {
    selectedDate = dateTime;
  }

  @observable
  String growthRaw = '60';

  @observable
  double growth = 60;

  @computed
  bool get isFormValid => growth > 0;

  @computed
  String get growthValue =>
      growthUnit == GrowthUnit.cm ? '${growth.toInt()}' : '${(growth / 100)}';

  @observable
  GrowthUnit growthUnit = GrowthUnit.cm;

  @action
  void switchGrowthUnit(GrowthUnit unit) {
    if (growthUnit != unit) {
      growthUnit = unit;
    }
  }

  @action
  void updateGrowthRaw(String val) {
    growth = double.tryParse(val) ?? 0;
  }

  @action
  void updateGrowth(double val) {
    growth = val;
  }

  @action
  void init() {}

  Future _add(GrowthInsertHeightDto data) async {
    return await restClient.growth.postGrowthHeight(dto: data);
  }

  Future add(String childId, String? notes) async {
    final GrowthInsertHeightDto dto = GrowthInsertHeightDto(
      childId: childId,
      height: growth.toString(),
      notes: notes,
      createdAt: selectedDate?.toString(),
    );
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    // Ждем завершения операции добавления
    await _add(dto);
  }
}
