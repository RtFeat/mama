import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class PaginatedLoadingWidget<R> extends StatelessWidget {
  final PaginatedListStore<R> store;
  final ObservableList<R>? Function()? listData;

  final Widget Function(BuildContext context, R item) itemBuilder;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final EdgeInsets? padding;

  final bool isReversed;

  final bool isFewLists;

  final EdgeInsets? itemsPadding;
  final ScrollController? scrollController;

  final Widget Function(int index, R item)? separator;

  /// Виджет для начальной загрузки (первой страницы)
  final Widget? initialLoadingWidget;

  /// Виджет для дополнительной загрузки (добавление данных)
  final Widget? additionalLoadingWidget;

  /// Виджет для отображения ошибки
  final Widget? errorWidget;

  /// Виджет для отображения пустых данных
  final Widget? emptyData;

  /// Логика при достижении конца списка
  final void Function()? onScrollEndReached;

  const PaginatedLoadingWidget({
    super.key,
    this.listData,
    required this.store,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.isReversed = false,
    this.isFewLists = false,
    this.itemsPadding,
    this.padding,
    this.scrollController,
    this.separator,
    this.initialLoadingWidget,
    this.additionalLoadingWidget,
    this.errorWidget,
    this.emptyData,
    this.onScrollEndReached,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.fetchFuture.status == FutureStatus.pending &&
            store.currentPage == 1) {
          // Начальная загрузка
          return initialLoadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        if (store.fetchFuture.status == FutureStatus.rejected) {
          // Ошибка загрузки
          return errorWidget ??
              Center(
                child: Text(
                  'Error loading data: ${store.fetchFuture.error}',
                ),
              );
        }

        if (store.listData.isEmpty) {
          // Пустые данные
          return emptyData ??
              const Center(
                child: Text('No data available'),
              );
        }
        return _DataWidget<R>(
          scrollController: scrollController,
          listData: listData == null ? null : listData!(),
          isFewLists: isFewLists,
          itemsPadding: itemsPadding,
          separator: separator,
          store: store,
          isReversed: isReversed,
          itemBuilder: itemBuilder,
          scrollDirection: scrollDirection,
          physics: physics,
          padding: padding,
        );
      },
    );
  }
}

class _DataWidget<R> extends StatelessWidget {
  final PaginatedListStore store;
  final List<R>? listData;
  final Widget Function(BuildContext context, R item) itemBuilder;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final bool isFewLists;

  final ScrollController? scrollController;

  final EdgeInsets? itemsPadding;

  final Widget Function(int index, R item)? separator;

  final bool isReversed;

  const _DataWidget({
    required this.scrollController,
    required this.listData,
    required this.isFewLists,
    required this.itemsPadding,
    required this.separator,
    required this.store,
    required this.itemBuilder,
    required this.scrollDirection,
    required this.physics,
    required this.padding,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final separatorWidget = separator ??
        (_, __) => Padding(
            padding: itemsPadding ??
                EdgeInsets.symmetric(
                    horizontal: scrollDirection == Axis.horizontal ? 8 : 0,
                    vertical: scrollDirection == Axis.vertical ? 8 : 0));

    if (isFewLists) {
      return SliverInfiniteList(
          isLoading: store.isLoading,
          separatorBuilder: (context, index) =>
              separatorWidget(index, listData?[index] ?? store.listData[index]),
          hasReachedMax: !store.hasMore,
          itemCount: listData?.length ?? store.listData.length,
          onFetchData: () => store.loadPage(queryParams: {}),
          itemBuilder: (context, index) =>
              itemBuilder(context, listData?[index] ?? store.listData[index]));
    }

    return InfiniteList(
      physics: physics,
      cacheExtent: 1000,
      scrollDirection: scrollDirection,
      padding: padding,
      scrollController: scrollController,
      reverse: isReversed,
      isLoading: store.isLoading,
      separatorBuilder: (context, index) =>
          separatorWidget(index, listData?[index] ?? store.listData[index]),
      hasReachedMax: !store.hasMore,
      itemCount: listData?.length ?? store.listData.length,
      onFetchData: () => store.loadPage(queryParams: {}),
      itemBuilder: (context, index) =>
          itemBuilder(context, listData?[index] ?? store.listData[index]),
    );
  }
}
