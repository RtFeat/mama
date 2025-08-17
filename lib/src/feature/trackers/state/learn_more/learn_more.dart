import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'learn_more.g.dart';

mixin LearnMoreMixin on Store {
  @observable
  bool isShowInfo = true;

  Future<bool> Function() get onLoad;
  Future Function(bool value) get onSet;

  @action
  Future<void> getIsShowInfo() async {
    isShowInfo = await onLoad();
  }

  @action
  Future<void> setIsShowInfo(bool value) async {
    isShowInfo = value;
    await onSet(value);
  }
}

class SimpleLearnMoreStore<T> extends _SimpleLearnMoreStore
    with _$SimpleLearnMoreStore {
  SimpleLearnMoreStore({
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _SimpleLearnMoreStore with Store, LearnMoreMixin {
  _SimpleLearnMoreStore({required this.onLoad, required this.onSet});

  @override
  final Future<bool> Function() onLoad;
  @override
  final Future<void> Function(bool) onSet;
}

class LearnMoreStore<T> = _LearnMoreStore<T> with _$LearnMoreStore;

abstract class _LearnMoreStore<T> extends PaginatedListStore<T>
    with Store, LearnMoreMixin {
  _LearnMoreStore({
    required this.onLoad,
    required this.onSet,
    required super.pageSize,
    required super.basePath,
    required super.apiClient,
    required super.testDataGenerator,
    required super.faker,
    required super.fetchFunction,
    required super.transformer,
  });

  @override
  final Future<bool> Function() onLoad;
  @override
  final Future<void> Function(bool) onSet;
}

// class LearnMoreStore<T> extends _LearnMoreStore with _$LearnMoreStore {
//   LearnMoreStore(
//       {required super.onLoad,
//       required super.onSet,
//       super.pageSize = 20,
//       required super.basePath,
//       required super.apiClient,
//       required super.testDataGenerator,
//       required super.faker,
//       required super.fetchFunction,
//       required super.transformer});
// }

// abstract class _LearnMoreStore<T> extends PaginatedListStore<T> with Store {
//   final Future<bool> Function() onLoad;
//   final Future Function(bool value) onSet;

//   _LearnMoreStore({
//     required super.pageSize,
//     required super.faker,
//     required this.onLoad,
//     required this.onSet,
//     required super.basePath,
//     required super.apiClient,
//     required super.fetchFunction,
//     required super.transformer,
//     required super.testDataGenerator,
//   });

//   @observable
//   bool isShowInfo = true;

//   @action
//   Future getIsShowInfo() async {
//     isShowInfo = await onLoad();
//   }

//   @action
//   Future setIsShowInfo(bool value) async {
//     isShowInfo = value;
//     onSet(value);
//   }
// }
