import 'package:mama/src/data.dart';

class ConsultationStore extends SingleDataStore<Consultation> {
  ConsultationStore({
    required RestClient restClient,
  }) : super(
          fetchFunction: (id) => restClient.get('${Endpoint.consultation}/$id'),
          transformer: (raw) {
            final data = Consultation.fromJson(raw!);
            return data;
          },
        );
}
