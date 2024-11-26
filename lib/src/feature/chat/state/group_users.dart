import 'package:mama/src/data.dart';

class GroupUsersStore extends PaginatedListStore<AccountModel> {
  GroupUsersStore({
    required RestClient restClient,
    required String chatId,
  }) : super(
            fetchFunction: (params) => restClient
                .get('${Endpoint().groupUsers}/$chatId', queryParams: params),
            transformer: (raw) {
              final List<AccountModel>? data = (raw['account'] as List?)
                  ?.map((e) => AccountModel.fromJson(e))
                  .toList();
              return data ?? [];
            });
}
