import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationRecordsState extends PaginatedListStore {
  ConsultationRecordsState({
    required super.apiClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().userConsultations,
          transformer: (raw) {
            final data = Consultations.fromJson(raw);
            return data.data ?? [];
          },
        );
}
