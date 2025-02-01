import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class SchoolsStore extends PaginatedListStore {
  SchoolsStore({
    required super.apiClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().schools,
          transformer: (raw) {
            final data = Schools.fromJson(raw);
            return data.schools ?? [];
          },
        );
}
