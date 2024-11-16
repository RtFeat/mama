import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

mixin LoadingDataStoreExtension<T> on Store {
  @observable
  ObservableFuture<T?> fetchFuture = ObservableFuture(Future.value());

  @observable
  T? data;

  @observable
  ObservableList<T> listData = ObservableList<T>();

  /// Общий метод загрузки данных
  @action
  Future<void> fetchData<R>(
    Future<R> Function() fetchFunction, // Запрос данных
    T Function(R raw) transform, // Преобразование данных в нужный формат
  ) async {
    try {
      fetchFuture = ObservableFuture(
        fetchFunction().then((raw) {
          final transformed = transform(raw);
          data = transformed; // Сохраняем данные для одиночного объекта
          return transformed;
        }),
      );
      await fetchFuture;
    } catch (error, stackTrace) {
      logger.error(error);
      logger.error(stackTrace);
      fetchFuture = ObservableFuture(Future.value());
      rethrow; // Прокидываем ошибку дальше
    }
  }

  /// Общий метод загрузки списка данных
  @action
  Future<void> fetchList<R>(
    Future<R> Function() fetchFunction, // Запрос данных
    List<T> Function(R raw) transform, // Преобразование данных в список
  ) async {
    try {
      fetchFuture = ObservableFuture(
        fetchFunction().then((raw) {
          final transformed = transform(raw);
          listData.addAll(transformed); // Добавляем элементы в список
          return;
        }),
      );
      await fetchFuture;
    } catch (error, stackTrace) {
      logger.error(error);
      logger.error(stackTrace);
      rethrow; // Прокидываем ошибку дальше
    }
  }
}
