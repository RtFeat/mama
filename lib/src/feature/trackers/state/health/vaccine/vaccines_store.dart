import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'vaccines_store.g.dart';

class VaccinesStore extends _VaccinesStore with _$VaccinesStore {
  VaccinesStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _VaccinesStore extends LearnMoreStore<EntityVaccinationMain>
    with Store {
  _VaccinesStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            //

            return EntityVaccinationMain(
                // id: faker.guid(),
                // name: faker.person.name(),
                // avatarUrl: faker.internet.avatar(),
                // dataStart: format.format(DateTime.now()),
                // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),
                );
          },
          basePath: Endpoint.vaccines,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 40,
          transformer: (raw) {
            final data = HealthResponseListVaccination.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        );
}
