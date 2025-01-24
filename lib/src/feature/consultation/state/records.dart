import 'package:mama/src/data.dart';

class ConsultationRecordsState extends PaginatedListStore {
  ConsultationRecordsState({
    required super.restClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().userConsultations,
          transformer: (raw) {
            final data = Consultations.fromJson(raw);
            return data.data ?? [];
          },
        );
}
