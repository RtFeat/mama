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
  // final GrowthStore? store;

  _AddGrowthViewStore({
    required this.restClient,
    // required this.store,
  });

  @observable
  DateTime? selectedDate = DateTime.now();

  @action
  void updateDateTime(DateTime? dateTime) {
    selectedDate = dateTime;
  }

  // @observable
  // EntityGrowthHistory? model;

  // @computed
  // bool get isAdd => model == null;

  @observable
  String growthRaw = '60';

  @observable
  double growth = 60;

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
    // if (growthUnit == GrowthUnit.cm) {
    //   growthRaw = val;
    // } else {
    //   final data = double.tryParse(val.replaceAll(',', '.'));
    //   if (data != null) {
    //     // final v = data * 10;
    //     // if(v > 10 && v < 150) {
    //     growthRaw = '$data';
    //     // }
    //   }
    // }
  }

  @action
  void updateGrowth(double val) {
    growth = val;
    // growthRaw = '$val';
  }

  @action
  void init(
      // EntityGrowthHistory? model
      ) {
    // this.model = model;

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    // growth = double.tryParse(model?.growths ?? '') ?? 36.6;
    // growthRaw = growth.toStringAsFixed(1).replaceAll('.', ',');
  }

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

    _add(dto).then((v) {
      // _addToList(dto);
    });
  }

  // void _addToList(GrowthInsertHeightDto? data) {

  //   // final EntityGrowthHistoryTotal? item =
  //   //     store?.listData.firstWhereOrNull((element) => element.title == day);

  //   final entity = EntityGrowthHistory(
  //     growths: data?.growth,
  //     time: DateTime.tryParse(data?.time ?? '')?.formattedTime,
  //     notes: data?.notes,
  //     isBad: data?.isBad,
  //   );

  //   if (item != null) {
  //     item.growthHistory?.add(entity);
  //   } else {
  //     store?.listData.add(EntityGrowthHistoryTotal(
  //       title: day,
  //       growthHistory: [
  //         entity,
  //       ],
  //     ));
  //   }
  // // }

  // Future update() async {
  //   if (model != null) {
  //     // return await restClient.health.patchHealthVaccination(
  //     //   id: model?.id ?? '',
  //     //   photo: image != null ? File(image!.path) : null,
  //     //   dataStart: selectedDate.toString(),
  //     //   clinic: clinic?.value,
  //     //   notes: comment?.value,
  //     // );
  //   }
  // }

  // Future delete() async {
  //   if (model != null) {
  //     return await restClient.health.deleteHealthVaccination(
  //         dto: HealthDeleteVaccination(id: model?.id ?? ''));
  //   }
  // }
}
