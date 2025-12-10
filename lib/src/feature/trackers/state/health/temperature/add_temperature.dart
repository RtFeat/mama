import 'package:collection/collection.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

part 'add_temperature.g.dart';

class AddTemperatureViewStore extends _AddTemperatureViewStore
    with _$AddTemperatureViewStore {
  AddTemperatureViewStore({
    required super.restClient,
    required super.store,
  });
}

abstract class _AddTemperatureViewStore with Store {
  final RestClient restClient;
  final TemperatureStore? store;

  _AddTemperatureViewStore({
    required this.restClient,
    required this.store,
  });

  @observable
  DateTime? selectedDate = DateTime.now();

  @action
  void updateDateTime(DateTime? dateTime) {
    selectedDate = dateTime;
  }

  @observable
  EntityTemperatureHistory? model;

  @computed
  bool get isAdd => model == null;

  @observable
  String temperatureRaw = '36,6';

  @observable
  double temperature = 36.6;

  @action
  void updateTemperatureRaw(String val) {
    temperatureRaw = val;
    final parsed = double.tryParse(val.replaceAll(',', '.'));
    if (parsed != null && parsed >= 35 && parsed <= 42) {
      temperature = parsed;
    }
  }

  @action
  void updateTemperature(double val) {
    temperature = val;
    temperatureRaw = val.toStringAsFixed(1).replaceAll('.', ',');
  }

  @action
  void init(EntityTemperatureHistory? model) {
    this.model = model;

    // if (model != null && model.photos != null && model.photos!.isNotEmpty) {
    //   imagesUrls = ObservableList.of(model.photos!.map((e) => e));
    // }

    temperature = double.tryParse(model?.temperatures ?? '') ?? 36.6;
    temperatureRaw = temperature.toStringAsFixed(1).replaceAll('.', ',');
  }

  Future _add(HealthInsertTemperatureDto data) async {
    return await restClient.health.postHealthTemperature(dto: data);
  }

  Future add(String childId, String? notes) async {
    final bool isBad = temperature > 37.5 || temperature < 36.5;
    final HealthInsertTemperatureDto dto = HealthInsertTemperatureDto(
      childId: childId,
      temperature: temperature.toString(),
      notes: notes,
      isBad: isBad,
      time: selectedDate?.toString(),
    );
    logger.info('Сохраняем данные для childId: $childId',
        runtimeType: runtimeType);

    _add(dto).then((v) {
      _addToList(dto);
    });
  }

  void _addToList(HealthInsertTemperatureDto? data) {
    final String day =
        '${selectedDate?.day} ${t.home.monthsData.withNumbers[(selectedDate?.month ?? 1) - 1]}';

    final EntityTemperatureHistoryTotal? item =
        store?.listData.firstWhereOrNull((element) => element.title == day);

    final entity = EntityTemperatureHistory(
      temperatures: data?.temperature,
      time: DateTime.tryParse(data?.time ?? '')?.formattedTime,
      notes: data?.notes,
      isBad: data?.isBad,
    );

    if (item != null) {
      item.temperatureHistory?.add(entity);
    } else {
      store?.listData.add(EntityTemperatureHistoryTotal(
        title: day,
        temperatureHistory: [
          entity,
        ],
      ));
    }
  }

  Future update() async {
    if (model != null) {
      // return await restClient.health.patchHealthVaccination(
      //   id: model?.id ?? '',
      //   photo: image != null ? File(image!.path) : null,
      //   dataStart: selectedDate.toString(),
      //   clinic: clinic?.value,
      //   notes: comment?.value,
      // );
    }
  }

  // Future delete() async {
  //   if (model != null) {
  //     return await restClient.health.deleteHealthVaccination(
  //         dto: HealthDeleteVaccination(id: model?.id ?? ''));
  //   }
  // }
}
