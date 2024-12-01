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
  Map<String, dynamic> queryParams = {};

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
    this.queryParams = {...this.queryParams, ...queryParams};

    logger.info('Current queryParams: ${this.queryParams}');

    final updatedParams = {
      ...this.queryParams,
      'page': '$currentPage',
      'offset': '${pageSize * (currentPage - 1)}'
    };

    fetchFuture = ObservableFuture(
      fetchFunction(updatedParams).then((rawData) {
        logger.info('Received rawData: $rawData');
        if (rawData != null) {
          final transformedData = transformer(rawData);
          logger.info('Transformed data length: ${transformedData?.length}');

          if (transformedData != null && transformedData.isNotEmpty) {
            // Здесь мы добавляем новые данные в listData
            listData
                .addAll(transformedData); // Добавляем данные с новой страницы

            // Проверка на наличие дополнительных страниц
            if (transformedData.length < pageSize) {
              hasMore =
                  false; // Если данных меньше, чем размер страницы, это последняя страница
              logger.info(
                  'Less data than pageSize, assuming no more pages available.');
            } else {
              currentPage++; // Увеличиваем номер текущей страницы
              hasMore = true; // Считаем, что есть еще данные
              logger
                  .info('Data loaded, currentPage incremented to $currentPage');
            }
          } else {
            // Если данных нет, завершаем пагинацию
            hasMore = false;
            logger.info('No data received, hasMore set to false');
          }
        } else {
          // Если не получили данных
          hasMore = false;
          logger.info('No rawData received, hasMore set to false');
        }
      }).catchError((e) {
        logger.error('Error in loadPage: $e');
        hasMore = false; // В случае ошибки завершаем загрузку
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
    listData.clear(); // Очищаем старые данные при сбросе пагинации
  }
}
