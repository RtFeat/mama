import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class SchoolStore extends SingleDataStore<SchoolModel> {
  SchoolStore({required ApiClient apiClient})
      : super(
          fetchFunction: (_) => apiClient.get(Endpoint.school),
          transformer: (v) {
            final data = v?['online_school'];
            return SchoolModel.fromJson(data);
          },
        );
}
