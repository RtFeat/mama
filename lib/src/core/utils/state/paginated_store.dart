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

    final updatedParams = {
      ...this.queryParams,
      'page': '$currentPage',
      'page_size': '$pageSize',
      'offset': '${pageSize * (currentPage - 1)}'
    };

    logger.info('Requesting page $currentPage with params: $updatedParams');

    fetchFuture = ObservableFuture(
      fetchFunction(updatedParams).then((rawData) {
        logger.info('Received rawData: $rawData');
        if (rawData != null) {
          final transformedData = transformer(rawData);
          logger.info('Transformed data length: ${transformedData?.length}');

          if (transformedData != null && transformedData.isNotEmpty) {
            final previousLength = listData.length;

            final uniqueData = transformedData.where((element) {
              final isUnique = !listData.contains(element);
              if (!isUnique) {
                logger.info('Duplicate data detected: $element');
              }
              return isUnique;
            }).toList();

            listData.addAll(uniqueData);

            logger.info(
                'Added ${uniqueData.length} unique items. Updated listData length: ${listData.length}, previous length: $previousLength');

            // Если уникальных данных меньше pageSize или список не увеличился
            if (uniqueData.isEmpty || uniqueData.length < pageSize) {
              hasMore = false;
              logger.info(
                  'No more unique data found or less than pageSize. Stopping pagination.');
            } else {
              currentPage++;
              hasMore = true;
              logger
                  .info('Data loaded, currentPage incremented to $currentPage');
            }
          } else {
            hasMore = false;
            logger.info('No data received, hasMore set to false');
          }
        } else {
          hasMore = false;
          logger.info('No rawData received, hasMore set to false');
        }
      }).catchError((e) {
        logger.error('Error in loadPage: $e');
        hasMore = false;
        throw Exception(e);
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
