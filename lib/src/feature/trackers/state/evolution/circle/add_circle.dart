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
    String? formatCreatedAt(DateTime? dt) {
      if (dt == null) return null;
      final d = dt.toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      String three(int v) => v.toString().padLeft(3, '0');
      return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
    }

    final String circleStr = circle % 1 == 0
        ? circle.toInt().toString()
        : circle.toString();

    final GrowthInsertCircleDto dto = GrowthInsertCircleDto(
      childId: childId,
      circle: circleStr,
      notes: notes,
      // POST expects space-separated local time per Swagger style
      createdAt: formatCreatedAt(selectedDate),
    );
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    // Ждем завершения операции добавления
    await _add(dto);
  }

  Future<void> edit({
    required String childId,
    required String id,
    String? notes,
  }) async {
    final String circleStr = circle % 1 == 0
        ? circle.toInt().toString()
        : circle.toString();

    final dto = GrowthChangeStatsCircleDto(
      stats: EntityCircle(
        id: id,
        childId: childId,
        circle: circleStr,
        // Заметку шлём отдельным PATCH /growth/circle/notes
        createdAt: selectedDate?.toUtc().toIso8601String(),
      ),
    );
    await restClient.growth.patchGrowthCircleStats(dto: dto);

    final String? trimmed = notes?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      await restClient.growth.patchGrowthCircleNotes(
        dto: GrowthChangeNotesCircleDto(
          id: id,
          notes: trimmed,
        ),
      );
    }
  }
}
