import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'learn_more.g.dart';

class LearnMoreStore<T> extends _LearnMoreStore with _$LearnMoreStore {
  LearnMoreStore(
      {required super.onLoad,
      required super.onSet,
      super.pageSize = 20,
      required super.basePath,
      required super.apiClient,
      required super.testDataGenerator,
      required super.faker,
      required super.fetchFunction,
      required super.transformer});
}

abstract class _LearnMoreStore<T> extends PaginatedListStore<T> with Store {
  final Future<bool> Function() onLoad;
  final Future Function(bool value) onSet;

  _LearnMoreStore({
    required super.pageSize,
    required super.faker,
    required this.onLoad,
    required this.onSet,
    required super.basePath,
    required super.apiClient,
    required super.fetchFunction,
    required super.transformer,
    required super.testDataGenerator,
  });

  @observable
  bool isShowInfo = true;

  @action
  Future getIsShowInfo() async {
    isShowInfo = await onLoad();
  }

  @action
  Future setIsShowInfo(bool value) async {
    isShowInfo = value;
    onSet(value);
  }
}
