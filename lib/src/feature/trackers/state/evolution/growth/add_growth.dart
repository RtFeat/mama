import 'package:dio/dio.dart';
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
    String? formatCreatedAt(DateTime? dt) {
      if (dt == null) return null;
      final d = dt.toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      String three(int v) => v.toString().padLeft(3, '0');
      return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
    }

    final String heightStr = growth % 1 == 0
        ? growth.toInt().toString()
        : growth.toString();

    final GrowthInsertHeightDto dto = GrowthInsertHeightDto(
      childId: childId,
      height: heightStr,
      notes: notes,
      // POST /growth/height expects space-separated local time per Swagger example
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
    final String heightStr = growth % 1 == 0
        ? growth.toInt().toString()
        : growth.toString();

    final dto = GrowthChangeStatsHeightDto(
      stats: EntityHeight(
        id: id,
        childId: childId,
        height: heightStr,
        notes: notes,
        createdAt: selectedDate?.toUtc().toIso8601String(),
      ),
    );
    try {
      await restClient.growth.patchGrowthHeightStats(dto: dto);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      if (status == 500) {
        // Fallback: delete existing and create new
        await restClient.growth.deleteGrowthHeightDeleteStats(
          dto: GrowthDeleteHeightDto(id: id),
        );
        await add(childId, notes);
      } else {
        rethrow;
      }
    }
  }
}
