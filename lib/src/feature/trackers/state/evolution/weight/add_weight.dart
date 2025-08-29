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
    final dto = GrowthInsertWeightDto(
      childId: childId,
      weight: '$totalWeightKg',
      notes: notes,
      createdAt: selectedDate?.toString(),
    );

    await restClient.growth.postGrowthWeight(dto: dto);
  }
}
