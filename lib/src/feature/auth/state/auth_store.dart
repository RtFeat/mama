import 'package:fresh_dio/fresh_dio.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'auth_store.g.dart';

class AuthStore extends _AuthStore with _$AuthStore {
  AuthStore({
    required super.tokenStorage,
    required super.apiClient,
  });
}

abstract class _AuthStore with Store {
  final Fresh tokenStorage;
  final ApiClient apiClient;

  _AuthStore({
    required this.tokenStorage,
    required this.apiClient,
  }) : super() {
    status = ObservableStream(tokenStorage.authenticationStatus);
  }

  @computed
  bool get isAuthorized => status.value == AuthenticationStatus.authenticated;

  @observable
  ObservableStream<AuthenticationStatus> status =
      ObservableStream(const Stream.empty());
}
