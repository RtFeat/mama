import 'package:mobx/mobx.dart';

typedef FilterFunction<R> = bool Function(R item);

mixin FilterableDataMixin<R> {
  ObservableMap<String, FilterFunction<R>> _filters = ObservableMap();

  /// Добавить или обновить фильтр
  void addFilter(String key, FilterFunction<R> filter) {
    _filters[key] = filter;
  }

  /// Удалить фильтр
  void removeFilter(String key) {
    _filters.remove(key);
  }

  /// Очистить все фильтры
  void clearFilters() {
    _filters.clear();
  }

  void setFilters(Map<String, FilterFunction<R>> filters) {
    _filters = ObservableMap.of(filters);
  }

  /// Применить фильтры к данным
  ObservableList<R> applyFilters(List<R> data) {
    final filteredData = data.where((item) {
      return _filters.values.every((filter) => filter(item));
    }).toList();

    return ObservableList.of(filteredData);
  }
}
