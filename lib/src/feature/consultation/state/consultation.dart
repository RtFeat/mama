import 'package:mama/src/data.dart';

class ConsultationStore extends SingleDataStore<Consultation> {
  ConsultationStore({
    required RestClient restClient,
    required String? id,
  }) : super(
          fetchFunction: () => restClient.get('${Endpoint.consultation}/$id'),
          transformer: (raw) {
            final data = Consultation.fromJson(raw!);
            return data;
          },
        );
}
