import 'package:mobx/mobx.dart';

import 'extensions/extensions.dart';

abstract class SingleDataStore<T> with Store, LoadingDataStoreExtension<T> {
  final Future<Map<String, Object?>?> Function()
      fetchFunction; // id стал необязательным
  final T Function(Map<String, dynamic>?) transformer;

  SingleDataStore({
    required this.fetchFunction,
    required this.transformer,
  });

  @action
  Future<void> loadData() async {
    // id как необязательный параметр
    await super.fetchData(
      () => fetchFunction(), // Передаем id (может быть null)
      (raw) => transformer(raw),
    );
  }
}
