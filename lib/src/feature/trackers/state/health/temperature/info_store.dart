import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'info_store.g.dart';

class TemperatureInfoStore extends _TemperatureInfoStore
    with _$TemperatureInfoStore {
  TemperatureInfoStore({required super.onLoad, required super.onSet});
}

abstract class _TemperatureInfoStore
    extends SimpleLearnMoreStore<EntityMainDrug> with Store {
  _TemperatureInfoStore({
    required super.onLoad,
    required super.onSet,
  });
}
