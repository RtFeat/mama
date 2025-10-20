import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'add_weight.g.dart';

enum WeightUnit { kg, g }

class AddWeightViewStore extends _AddWeightViewStore with _$AddWeightViewStore {
  AddWeightViewStore({
    required super.restClient,
  });
}

abstract class _AddWeightViewStore with Store {
  final RestClient restClient;

  _AddWeightViewStore({
    required this.restClient,
  });

  @observable
  DateTime? selectedDate = DateTime.now();

  @action
  void updateDateTime(DateTime? dateTime) {
    selectedDate = dateTime;
  }

  @observable
  int kilograms = 0;

  @observable
  int grams = 0;

  @computed
  double get totalWeightKg => kilograms + grams / 1000;

  @computed
  int get totalWeightGrams => (totalWeightKg * 1000).toInt();

  @computed
  bool get isFormValid => totalWeightGrams > 0;

  @computed
  String get inputValue =>
      weightUnit == WeightUnit.kg ? '$kilograms,$grams' : '$totalWeightGrams';

  @action
  void updateKilograms(int value) {
    kilograms = value;
  }

  @action
  void updateGrams(int value) {
    if (value < 1000) {
      grams = value;
    }
  }

  @action
  void updateWeightRaw(String raw) {
    if (weightUnit == WeightUnit.kg) {
      final parts = raw.split(',');
      kilograms = int.tryParse(parts[0]) ?? 0;
      grams = (parts.length > 1 && parts[1].isNotEmpty)
          ? int.tryParse(parts[1].padRight(2, '0')) ?? 0
          : 0;
    } else {
      int totalGrams = int.tryParse(raw) ?? 0;
      kilograms = totalGrams ~/ 1000;
      grams = totalGrams % 1000;
    }
  }

  @observable
  WeightUnit weightUnit = WeightUnit.kg;

  @action
  void switchWeightUnit(WeightUnit unit) {
    if (weightUnit != unit) {
      weightUnit = unit;
    }
  }

  Future<void> add(String childId, String? notes) async {
    String? formatCreatedAt(DateTime? dt) {
      if (dt == null) return null;
      final d = dt.toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      String three(int v) => v.toString().padLeft(3, '0');
      return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
    }

    final dto = GrowthInsertWeightDto(
      childId: childId,
      weight: '$totalWeightKg',
      notes: notes,
      // POST expects space-separated local time per Swagger style
      createdAt: formatCreatedAt(selectedDate),
    );

    await restClient.growth.postGrowthWeight(dto: dto);
  }

  Future<void> edit({
    required String childId,
    required String id,
    String? notes,
  }) async {
    final dto = GrowthChangeStatsWeightDto(
      stats: EntityWeight(
        id: id,
        childId: childId,
        weight: '$totalWeightKg',
        // Изменение заметки делаем отдельным PATCH /growth/weight/notes
        // поэтому здесь не передаём notes, чтобы избежать несогласованности API
        createdAt: selectedDate?.toUtc().toIso8601String(),
      ),
    );

    await restClient.growth.patchGrowthWeightStats(dto: dto);

    // Если пользователь ввёл новую заметку, отправим отдельным запросом
    final String? trimmed = notes?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      await restClient.growth.patchGrowthWeightNotes(
        dto: GrowthChangeNotesWeightDto(
          id: id,
          notes: trimmed,
        ),
      );
    }
  }
}
