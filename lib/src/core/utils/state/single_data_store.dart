import 'package:mobx/mobx.dart';

import 'extensions/extensions.dart';

abstract class SingleDataStore<T> with Store, LoadingDataStoreExtension<T> {
  final Future<Map<String, Object?>?> Function() fetchFunction;
  final T Function(Map<String, dynamic>?) transformer;

  SingleDataStore({
    required this.fetchFunction,
    required this.transformer,
  });

  @action
  Future<void> loadData() async {
    await super.fetchData(
      () => fetchFunction(),
      (raw) => transformer(raw),
    );
  }
}
