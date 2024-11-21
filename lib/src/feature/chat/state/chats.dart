import 'package:mama/src/data.dart';

class ChatsStore extends PaginatedListStore<SingleChatItem> {
  ChatsStore({required super.fetchFunction})
      : super(transformer: (raw) {
          final List<SingleChatItem>? data = (raw['chats'] as List?)
              ?.map((e) => SingleChatItem.fromJson(e))
              .toList();
          return data ?? [];
        });
}
