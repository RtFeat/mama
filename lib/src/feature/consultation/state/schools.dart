import 'package:mama/src/data.dart';

class SchoolsStore extends PaginatedListStore {
  SchoolsStore({
    required super.restClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().schools,
          transformer: (raw) {
            final data = Schools.fromJson(raw);
            return data.schools ?? [];
          },
        );
}
