import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'extensions/extensions.dart';

abstract class PaginatedListStore<R> with Store, LoadingDataStoreExtension<R> {
  final Future<Map<String, Object?>?> Function(Map<String, dynamic>)
      fetchFunction;
  final List<R> Function(Map<String, dynamic>) transformer;

  PaginatedListStore({
    required this.fetchFunction,
    required this.transformer,
  });

  @observable
  int currentPage = 1;

  @observable
  bool hasMore = true;

  @observable
  bool isLoading = false;

  @action
  Future<void> loadPage({
    required Map<String, dynamic> queryParams,
  }) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    final updatedParams = {...queryParams, 'page': '$currentPage'};

    fetchFuture = ObservableFuture(
      fetchFunction(updatedParams).then((rawData) {
        if (rawData != null) {
          final transformedData = transformer(rawData);
          if (transformedData.isEmpty) {
            hasMore = false;
          } else {
            currentPage++;
            listData.addAll(transformedData);
          }
        }
      }).catchError((e) {
        logger.error(e);
      }).whenComplete(() {
        isLoading = false;
      }),
    );

    await fetchFuture;
  }

  @action
  void resetPagination() {
    currentPage = 1;
    hasMore = true;
    listData.clear();
  }
}
