import 'package:flutter/foundation.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'verify_state.g.dart';

class VerifyStore extends _VerifyStore with _$VerifyStore {
  VerifyStore({
    required super.restClient,
    required super.tokenStorage,
  });
}

abstract class _VerifyStore with Store {
  final RestClient restClient;
  final Fresh tokenStorage;

  _VerifyStore({
    required this.restClient,
    required this.tokenStorage,
  });

  @observable
  String formattedPhoneNumber = '';

  @action
  void setPhoneNumber(String value) {
    formattedPhoneNumber = value;
  }

  @computed
  String get phoneNumber =>
      '+7${formattedPhoneNumber.replaceAll(' ', '').replaceAll('-', '')}';

  @computed
  bool get isValid => error == null;

  @observable
  String? error;

  @observable
  bool isRegistered = false;

  @action
  void sendCode() {
    restClient.post(
      Endpoint().sendCode,
      body: {
        'phone': phoneNumber,
        'is_sms': !kDebugMode,
      },
    );
  }

  @action
  void update(
    String value,
    bool isLogin, {
    RegisterData? data,
  }) {
    if (value.length == 4) {
      logger.info('len $value');

      login(value, data: data);
    } else {
      error = null;
    }
  }

  @observable
  bool isUser = true;

  @action
  void setIsUser(bool value) => isUser = value;

  @action
  void login(
    String code, {
    RegisterData? data,
  }) {
    restClient.post(Endpoint().login, body: {
      'code': code,
      'phone': phoneNumber,
      'fcm_token': '' // TODO: add fcm token
    }).then((v) async {
      final String? refreshToken = v?['refresh_token'] as String?;

      logger.info('refreshToken: $refreshToken');

      final String? state = v?['state'] as String?;

      final String? role = v?['role'] as String?;

      if (refreshToken != null) {
        await tokenStorage
            .setToken(OAuth2Token(accessToken: '', refreshToken: refreshToken));

        logger.info('Status: $state');

        if (role != null) {
          setIsUser(role == 'USER');
          //   setRole(Role.values.firstWhere((e) => e.name == role));
        }

        if (state != null && state != 'UNREGISTERED') {
          isRegistered = true;
        }
        logger.info('isRegistered: $isRegistered');
      } else {
        error = t.auth.invalidPassword;
      }
    }).catchError((e) {
      error = t.auth.invalidPassword;
    });
  }

  void register({
    required RegisterData data,
  }) async {
    final OAuth2Token? token = await tokenStorage.token;

    try {
      restClient.post(Endpoint().register, headers: {
        'Refresh-Token': 'Bearer ${token?.refreshToken}',
      }, body: {
        'account': data.user.toJson(),
        'child': data.child.toJson(),
        if (data.city.isNotEmpty)
          'user': {
            'city': data.city,
          }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void logout() async {
    // await tokenStorage.clearTokenPair();

    restClient.get(Endpoint().logout).then((_) async {
      await tokenStorage.setToken(null);
      router.pushReplacementNamed(AppViews.startScreen);
    });
  }
}
