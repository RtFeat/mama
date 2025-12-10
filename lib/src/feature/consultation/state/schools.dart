import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class SchoolsStore extends PaginatedListStore {
  SchoolsStore({
    required super.apiClient,
    required super.fetchFunction,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return SchoolModel(
                id: faker.datatype.uuid(),
                account: AccountModel.mock(faker),
                title: faker.lorem.word(),
                articlesCount: faker.datatype.number(max: 100));
          },
          basePath: Endpoint().schools,
          transformer: (raw) {
            final data = Schools.fromJson(raw);
            // return data.schools ?? [];

            return {
              'main': data.schools ?? [],
            };
          },
        );
}
