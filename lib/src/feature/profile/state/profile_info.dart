import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'profile_info.g.dart';

class ProfileInfoViewStore extends _ProfileInfoViewStore
    with _$ProfileInfoViewStore {
  ProfileInfoViewStore({
    required super.apiClient,
  });
}

abstract class _ProfileInfoViewStore with Store {
  final ApiClient apiClient;

  _ProfileInfoViewStore({
    required this.apiClient,
  });

  Future createChat(String userId) async {
    apiClient.post(Endpoint().createChat, body: {
      'account_id': userId,
    }).then((v) {
      final Map<String, dynamic>? map = v != null && v.keys.contains('chat')
          ? v['chat'] as Map<String, dynamic>?
          : null;

      if (map != null) {
        final SingleChatItem chat = SingleChatItem.fromJson(map);

        router.pushNamed(AppViews.chatView, extra: {'item': chat});
      }
    });
  }
}
