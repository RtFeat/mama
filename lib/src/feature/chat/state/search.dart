import 'package:mobx/mobx.dart';

part 'search.g.dart';

class SearchStore<T> extends _SearchStore with _$SearchStore {
  final ObservableList<T> data;

  SearchStore({
    required this.data,
  });
}

abstract class _SearchStore with Store {
  @observable
  String? query;

  @action
  void setQuery(String value) {
    query = value;
  }
}
