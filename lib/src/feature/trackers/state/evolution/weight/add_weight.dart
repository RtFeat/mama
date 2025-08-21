import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'add_weight.g.dart';

enum WeightUnit { kg, g }

class AddWeightViewStore extends _AddWeightViewStore with _$AddWeightViewStore {
  AddWeightViewStore({
    required super.restClient,
    // required super.store,
  });
}

abstract class _AddWeightViewStore with Store {
  final RestClient restClient;
  // final WeightStore? store;

  _AddWeightViewStore({
    required this.restClient,
    // required this.store,
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
  // @observable
  // EntityWeightHistory? model;

  // @computed
  // bool get isAdd => model == null;

  @observable
  WeightUnit weightUnit = WeightUnit.kg;

  @action
  void switchWeightUnit(WeightUnit unit) {
    if (weightUnit != unit) {
      weightUnit = unit;
    }
  }

  @action
  void init(
      // EntityWeightHistory? model
      ) {
    // this.model = model;

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    // Weight = double.tryParse(model?.Weights ?? '') ?? 36.6;
    // WeightRaw = Weight.toStringAsFixed(1).replaceAll('.', ',');
  }

  Future _add(GrowthInsertWeightDto data) async {
    return await restClient.growth.postGrowthWeight(dto: data);
  }

  Future add(String childId, String? notes) async {
    //   final bool isBad = Weight > 37.5 || Weight < 36.5;
    //   final HealthInsertWeightDto dto = HealthInsertWeightDto(
    //     childId: childId,
    //     Weight: Weight.toString(),
    //     notes: notes,
    //     isBad: isBad,
    //     time: selectedDate?.toString(),
    //   );
    //   logger.info('Сохраняем данные для childId: $childId',
    //       runtimeType: runtimeType);

    final GrowthInsertWeightDto dto = GrowthInsertWeightDto(
      childId: childId,
      weight: '$totalWeightKg',
      notes: notes,
      createdAt: selectedDate?.toString(),
    );

    _add(dto).then((v) {
      // _addToList(dto);
    });
  }

  // void _addToList(HealthInsertWeightDto? data) {
  //   final String day =
  //       '${selectedDate?.day} ${t.home.monthsData.withNumbers[(selectedDate?.month ?? 1) - 1]}';

  //   final EntityWeightHistoryTotal? item =
  //       store?.listData.firstWhereOrNull((element) => element.title == day);

  //   final entity = EntityWeightHistory(
  //     Weights: data?.Weight,
  //     time: DateTime.tryParse(data?.time ?? '')?.formattedTime,
  //     notes: data?.notes,
  //     isBad: data?.isBad,
  //   );

  //   if (item != null) {
  //     item.WeightHistory?.add(entity);
  //   } else {
  //     store?.listData.add(EntityWeightHistoryTotal(
  //       title: day,
  //       WeightHistory: [
  //         entity,
  //       ],
  //     ));
  //   }
  // }

  // Future update() async {
  //   if (model != null) {
  // return await restClient.health.patchHealthVaccination(
  //   id: model?.id ?? '',
  //   photo: image != null ? File(image!.path) : null,
  //   dataStart: selectedDate.toString(),
  //   clinic: clinic?.value,
  //   notes: comment?.value,
  // );
  //   }
  // }

  // Future delete() async {
  //   if (model != null) {
  //     return await restClient.health.deleteHealthVaccination(
  //         dto: HealthDeleteVaccination(id: model?.id ?? ''));
  //   }
  // }
}
