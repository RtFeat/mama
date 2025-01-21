import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStore extends _UserStore with _$UserStore {
  UserStore({
    required super.restClient,
    required super.verifyStore,
  });
}

abstract class _UserStore with Store {
  final RestClient restClient;
  final VerifyStore verifyStore;
  _UserStore({required this.restClient, required this.verifyStore});

  @observable
  ObservableFuture<UserData> fetchUserDataFuture = emptyResponse;

  @observable
  UserData? userData;

  @computed
  AccountModel get account =>
      userData?.account ??
      AccountModel(
          gender: Gender.female, firstName: '', secondName: '', phone: '');

  @computed
  bool get isPro =>
      // kDebugMode ||
      account.status == Status.trial || account.status == Status.subscribed;

  @computed
  // TODO: change this in production
  Role get role => account.role ?? Role.user;
  // Role get role => Role.doctor;

  @computed
  UserModel get user =>
      userData?.user ??
      UserModel(
        accountId: '',
        city: '',
        createdId: '',
        endPrime: '',
        id: '',
        roles: [],
        startPrime: '',
        typePrime: '',
        updatedId: '',
      );

  @computed
  bool get isChanged =>
      account.isChanged || children.where((e) => e.isChanged).isNotEmpty;

  @observable
  ObservableList<ChildModel> children = ObservableList();

  @observable
  ChildModel? selectedChild;

  @computed
  List<ChildModel> get changedDataOfChild =>
      children.where((element) => element.isChanged).toList();

  @computed
  bool get hasResults =>
      fetchUserDataFuture != emptyResponse &&
      fetchUserDataFuture.status == FutureStatus.fulfilled;

  static ObservableFuture<UserData> emptyResponse = ObservableFuture.value(
      UserData(
          account:
              AccountModel(
                  gender: Gender.female,
                  firstName: '',
                  phone: '',
                  secondName: ''),
          childs: [],
          user: UserModel(
              accountId: '',
              city: '',
              createdId: '',
              endPrime: '',
              id: '',
              roles: [],
              startPrime: '',
              typePrime: '',
              updatedId: '')));

  @action
  void updateData({
    String? city,
    String? firstName,
    String? secondName,
    String? email,
    String? info,
    String? profession,
  }) {
    final bool isDoctor = role == Role.doctor;

    restClient
        .patch(isDoctor ? '${Endpoint.doctor}/' : '${Endpoint.user}/', body: {
      if (city != null) 'city': city,
      if (firstName != null) 'first_name': firstName,
      if (secondName != null) 'second_name': secondName,
      if (email != null) 'email': email,
      if (info != null) 'info': info,
      if (profession != null) 'profession': profession,
    }).then((v) {
      account.setIsChanged(false);
    });
  }

  @action
  Future<UserData> getData() async {
    final Future<UserData> future =
        restClient.get(Endpoint().userData).then((v) {
      if (v != null) {
        final data = UserData.fromJson(v);
        if (data.account != null) {
          selectedChild = data.childs?.first;
          children = ObservableList.of(data.childs ?? []);
          return data;
        } else {
          verifyStore.logout();
        }
      }
      return emptyResponse;
    });

    fetchUserDataFuture = ObservableFuture(future);

    return userData = await future;
  }

  @action
  void updateAvatar(XFile file) {
    FormData formData = FormData.fromMap({
      'avatar': MultipartFile.fromFileSync(file.path, filename: file.name),
    });

    restClient.put(Endpoint().accountAvatar, body: formData).then((v) {
      account.setAvatar(
          '${const Config().apiUrl}${Endpoint.avatar}/${v?['avatar']}');
    });
  }

  @action
  void selectChild({required ChildModel child}) {
    selectedChild = child;
  }
}
