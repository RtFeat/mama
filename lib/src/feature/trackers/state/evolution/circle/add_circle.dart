import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_circle.g.dart';

enum CircleUnit { cm, m }

class AddCircleViewStore extends _AddCircleViewStore with _$AddCircleViewStore {
  AddCircleViewStore({
    required super.restClient,
    // required super.store,
  });
}

abstract class _AddCircleViewStore with Store {
  final RestClient restClient;

  _AddCircleViewStore({
    required this.restClient,
  });

  @observable
  DateTime? selectedDate = DateTime.now();

  @action
  void updateDateTime(DateTime? dateTime) {
    selectedDate = dateTime;
  }

  @observable
  String circleRaw = '35';

  @observable
  double circle = 35;

  @computed
  bool get isFormValid => circle > 0;

  @computed
  String get circleValue =>
      circleUnit == CircleUnit.cm ? '${circle.toInt()}' : '${(circle * 10)}';

  @observable
  CircleUnit circleUnit = CircleUnit.cm;

  @action
  void switchCircleUnit(CircleUnit unit) {
    if (circleUnit != unit) {
      circleUnit = unit;
    }
  }

  @action
  void updateCircleRaw(String val) {
    circle = double.tryParse(val) ?? 0;
  }

  @action
  void updateCircle(double val) {
    circle = val;
  }

  @action
  void init() {}

  Future _add(GrowthInsertCircleDto data) async {
    return await restClient.growth.postGrowthCircle(dto: data);
  }

  Future add(String childId, String? notes) async {
    final GrowthInsertCircleDto dto = GrowthInsertCircleDto(
      childId: childId,
      circle: circle.toString(),
      notes: notes,
      createdAt: selectedDate?.toString(),
    );
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    _add(dto).then((v) {
      // _addToList(dto);
    });
  }
}
