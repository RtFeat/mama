import 'package:mama/src/data.dart';

class SchoolStore extends SingleDataStore<SchoolModel> {
  SchoolStore({required RestClient restClient})
      : super(
          fetchFunction: (_) => restClient.get(Endpoint.school),
          transformer: (v) {
            final data = v?['online_school'];
            return SchoolModel.fromJson(data);
          },
        );
}
