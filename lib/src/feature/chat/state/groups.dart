import 'package:mama/src/data.dart';

class GroupsStore extends PaginatedListStore<GroupItem> {
  GroupsStore({required super.fetchFunction})
      : super(transformer: (raw) {
          // final data =  ChatsData.fromJson(raw);

          final List<GroupItem>? data = (raw['chats'] as List?)
              ?.map((e) => GroupItem.fromJson(e))
              .toList();
          return data ?? [];
        });
}
