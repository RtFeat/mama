import 'package:mama/src/data.dart';

class DoctorsState extends PaginatedListStore {
  DoctorsState({
    required super.restClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint.doctor,
          transformer: (raw) {
            final data = Doctors.fromJson(raw);
            return data.data ?? [];
          },
        );
}
