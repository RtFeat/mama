import 'package:mama/src/data.dart';

class MessagesStore extends PaginatedListStore<MessageItem> {
  MessagesStore({
    required RestClient restClient,
    required String chatType,
    super.pageSize = 20,
  }) : super(
            fetchFunction: (params) => restClient
                .get('${Endpoint().messages}/$chatType', queryParams: params),
            transformer: (raw) {
              final List<MessageItem>? data = (raw['messages'] as List?)
                  ?.map((e) => MessageItem.fromJson(e))
                  .toList();
              return data ?? [];
            });
}
