import 'package:mobx/mobx.dart';

import 'extensions/extensions.dart';

abstract class SingleDataStore<T> with Store, LoadingDataStoreExtension<T> {
  final Future<Map<String, Object?>?> Function(String? id) fetchFunction;
  final T Function(Map<String, dynamic>?) transformer;

  SingleDataStore({
    required this.fetchFunction,
    required this.transformer,
  });

  @action
  Future<void> loadData({String? id}) async {
    await super.fetchData(
      () => fetchFunction(id),
      (raw) => transformer(raw),
    );
  }
}
