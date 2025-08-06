import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'doctor_visits_store.g.dart';

class DoctorVisitsStore extends _DoctorVisitsStore with _$DoctorVisitsStore {
  DoctorVisitsStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
  });
}

abstract class _DoctorVisitsStore extends LearnMoreStore<EntityMainDoctor>
    with Store {
  _DoctorVisitsStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            //

            return EntityMainDoctor(
                // id: faker.guid(),
                // name: faker.person.name(),
                // avatarUrl: faker.internet.avatar(),
                // dataStart: format.format(DateTime.now()),
                // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),
                );
          },
          basePath: Endpoint.doctorVisit,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = HealthResponseListConsDoctor.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        );
}
