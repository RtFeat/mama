import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'drugs_store.g.dart';

class DrugsStore extends _DrugsStore with _$DrugsStore {
  DrugsStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _DrugsStore extends LearnMoreStore<EntityMainDrug> with Store {
  _DrugsStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            //

            return EntityMainDrug(
              // id: faker.guid(),
              // name: faker.person.name(),
              // avatarUrl: faker.internet.avatar(),
              // dataStart: format.format(DateTime.now()),
              // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),

              reminder: ObservableList(),
              reminderAfter: ObservableList(),
            );
          },
          basePath: Endpoint.drugs,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = HealthResponseListDrug.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        );

  @observable
  bool isShowCompleted = false;

  @action
  void setIsShowCompleted(bool value) {
    isShowCompleted = value;
  }

  @computed
  ObservableList get completedList => ObservableList.of(listData
      .where((e) => e is EntityMainDrug && (e.isEnd ?? false))
      .toList());
}
