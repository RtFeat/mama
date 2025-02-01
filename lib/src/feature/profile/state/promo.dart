import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'promo.g.dart';

class PromoViewStore extends _PromoViewStore with _$PromoViewStore {
  PromoViewStore({
    required super.apiClient,
  });
}

abstract class _PromoViewStore with Store {
  _PromoViewStore({
    required this.apiClient,
  });
  final ApiClient apiClient;

  Future<bool> activatePromo(String promocode) async {
    return apiClient.post(Endpoint().promocode, queryParams: {
      'promocode': promocode,
    }, body: {}).then((v) {
      logger.info('Promo data: $v');
      if (v?['status_code'] == 404) {
        return false;
      }
      return true;
    });
  }
}
