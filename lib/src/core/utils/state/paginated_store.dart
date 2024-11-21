import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'extensions/extensions.dart';

abstract class PaginatedListStore<R> with Store, LoadingDataStoreExtension<R> {
  final int pageSize;

  final Future<Map<String, Object?>?> Function(Map<String, dynamic>)
      fetchFunction;
  final List<R>? Function(Map<String, dynamic>) transformer;

  PaginatedListStore({
    this.pageSize = 10,
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
    logger.info('Starting loadPage');
    logger.info('isLoading: $isLoading, hasMore: $hasMore');

    if (isLoading || !hasMore) {
      logger.info('Skipping loadPage due to isLoading or no more data');
      return;
    }

    isLoading = true;
    final updatedParams = {...queryParams, 'page': '$currentPage'};

    fetchFuture = ObservableFuture(
      fetchFunction(updatedParams).then((rawData) {
        logger.info('Received rawData: $rawData');
        if (rawData != null) {
          final transformedData = transformer(rawData);
          logger.info('Transformed data length: ${transformedData?.length}');
          if (transformedData != null && transformedData.isNotEmpty) {
            // Если количество данных меньше, чем страница, но данные есть
            if (transformedData.length <= pageSize) {
              hasMore = false; // Мы считаем, что это последняя страница
              listData.addAll(transformedData);
              logger.info('Less data than expected, hasMore set to false');
            } else {
              currentPage++; // Если данные есть, увеличиваем страницу
              listData.addAll(transformedData);
              logger.info('Data loaded, currentPage: $currentPage');
            }
          } else {
            hasMore = false; // Нет данных, ставим hasMore в false
            logger.info('No data received, hasMore set to false');
          }
        } else {
          hasMore = false;
          logger.info('No rawData received, hasMore set to false');
        }
      }).catchError((e) {
        logger.error('Error in loadPage: $e');
        hasMore = false;
      }).whenComplete(() {
        isLoading = false;
        logger.info('LoadPage completed');
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
