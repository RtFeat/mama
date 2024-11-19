import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

class PaginatedLoadingWidget<R> extends StatefulWidget {
  final PaginatedListStore<R> store;
  final Widget Function(BuildContext context, R item) itemBuilder;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;

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
    required this.store,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.initialLoadingWidget,
    this.additionalLoadingWidget,
    this.errorWidget,
    this.emptyData,
    this.onScrollEndReached,
  });

  @override
  _PaginatedLoadingWidgetState<R> createState() =>
      _PaginatedLoadingWidgetState<R>();
}

class _PaginatedLoadingWidgetState<R> extends State<PaginatedLoadingWidget<R>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    // Добавляем Listener для управления подгрузкой
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent &&
          widget.store.hasMore &&
          widget.store.fetchFuture.status != FutureStatus.pending) {
        if (widget.onScrollEndReached != null) {
          widget.onScrollEndReached!();
        } else {
          widget.store.loadPage(queryParams: {});
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Очищаем контроллер
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.store.fetchFuture.status == FutureStatus.pending &&
            widget.store.currentPage == 1) {
          // Начальная загрузка
          return widget.initialLoadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        if (widget.store.fetchFuture.status == FutureStatus.rejected) {
          // Ошибка загрузки
          return widget.errorWidget ??
              Center(
                child: Text(
                  'Error loading data: ${widget.store.fetchFuture.error}',
                ),
              );
        }

        if (widget.store.listData.isEmpty) {
          // Пустые данные
          return widget.emptyData ??
              const Center(
                child: Text('No data available'),
              );
        }

        return ListView.builder(
          controller: _controller,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          padding: widget.padding,
          itemCount: widget.store.listData.length +
              (widget.store.hasMore ? 1 : 0), // Добавляем место для индикатора
          itemBuilder: (context, index) {
            if (index >= widget.store.listData.length) {
              // Индикатор дополнительной загрузки
              return widget.additionalLoadingWidget ??
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
            }
            return widget.itemBuilder(context, widget.store.listData[index]);
          },
        );
      },
    );
  }
}
