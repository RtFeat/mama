import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationRecordsState extends PaginatedListStore {
  ConsultationRecordsState({
    required super.apiClient,
    required super.fetchFunction,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return Consultation(
              id: faker.datatype.uuid(),
              patient: AccountModel.mock(faker),
              doctor: DoctorModel.mock(faker),
            );
          },
          basePath: Endpoint().userConsultations,
          transformer: (raw) {
            final data = Consultations.fromJson(raw);
            return data.data ?? [];
          },
        );
}
