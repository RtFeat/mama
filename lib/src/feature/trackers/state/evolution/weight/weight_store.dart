import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'weight_store.g.dart';

class WeightStore extends _WeightStore with _$WeightStore {
  WeightStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _WeightStore extends LearnMoreStore<EntityTableWeight>
    with Store {
  _WeightStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            //

            return EntityTableWeight(
                // id: faker.guid(),
                // name: faker.person.name(),
                // avatarUrl: faker.internet.avatar(),
                // dataStart: format.format(DateTime.now()),
                // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),
                );
          },
          basePath: Endpoint.weight,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 40,
          transformer: (raw) {
            final data = GrowthGetWeightResponse.fromJson(raw);

            return {
              'main': [data.list ?? EntityTableWeight()],
            };
          },
        );
}
