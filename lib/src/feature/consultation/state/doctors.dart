import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class DoctorsState extends PaginatedListStore {
  DoctorsState({
    required super.apiClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint.doctor,
          transformer: (raw) {
            final data = Doctors.fromJson(raw);
            return data.data ?? [];
          },
        );
}
