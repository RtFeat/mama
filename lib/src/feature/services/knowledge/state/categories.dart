import 'package:mama/src/data.dart';

class CategoriesStore extends PaginatedListStore<CategoryModel> {
  CategoriesStore({
    required RestClient restClient,
  }) : super(
          fetchFunction: (params) =>
              restClient.get(Endpoint.categories, queryParams: params),
          transformer: (raw) {
            logger.info('raw: $raw');
            final data = List.from(raw['list'] ?? [])
                .map((e) => CategoryModel.fromJson(e))
                .toList();

            return data;
          },
        );
}
