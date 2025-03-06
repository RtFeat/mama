import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'user.g.dart';

class UserStore<UserData> extends _UserStore with _$UserStore {
  UserStore({
    required super.apiClient,
    required super.verifyStore,
    required super.faker,
  });
}

abstract class _UserStore extends SingleDataStore<UserData> with Store {
  final VerifyStore verifyStore;
  _UserStore({
    required super.apiClient,
    required this.verifyStore,
    required super.faker,
  }) : super(
          transformer: (raw) {
            if (raw != null) {
              final data = UserData.fromJson(raw);
              if (data.account != null) {
                return data;
              } else {
                verifyStore.logout();
              }
            }
            return UserData(account: null, childs: [], user: null);
          },
          testDataGenerator: () {
            return UserData(
              account: AccountModel.mock(faker),
              childs: List.generate(faker.datatype.number(max: 3),
                  (index) => ChildModel.mock(faker)),
              user: UserModel.mock(faker),
            );
          },
          fetchFunction: (id) => apiClient.get(Endpoint().userData),
        );

  @action
  void setUserData(UserData? data) {
    if (data != null) {
      children = ObservableList.of(data.childs ?? []);
      selectedChild = children.isNotEmpty ? children.first : null;
    }
  }

  @computed
  AccountModel get account =>
      data?.account ??
      AccountModel(
          gender: Gender.female, firstName: '', secondName: '', phone: '');

  @computed
  bool get isPro =>
      kDebugMode ||
      account.status == Status.trial ||
      account.status == Status.subscribed;

  @computed
  Role get role => account.role ?? Role.user;
  // Role get role => Role.doctor;

  @computed
  UserModel get user => data?.user ?? UserModel.mock(faker);

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

    apiClient
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

  // @action
  // Future<UserData> getData() async {
  //   final Future<UserData> future =
  //       apiClient.get(Endpoint().userData).then((v) {
  //     if (v != null) {
  //       final data = UserData.fromJson(v);
  //       if (data.account != null) {
  //         selectedChild = data.childs?.first;
  //         children = ObservableList.of(data.childs ?? []);
  //         return data;
  //       } else {
  //         verifyStore.logout();
  //       }
  //     }
  //     return emptyResponse;
  //   });

  //   fetchUserDataFuture = ObservableFuture(future);

  //   return userData = await future;
  // }

  @action
  void updateAvatar(XFile file) {
    FormData formData = FormData.fromMap({
      'avatar': MultipartFile.fromFileSync(file.path, filename: file.name),
    });

    apiClient.put(Endpoint().accountAvatar, body: formData).then((v) {
      account.setAvatar(
          '${const AppConfig().apiUrl}${Endpoint.avatar}/${v?['avatar']}');
    });
  }

  @action
  void selectChild({required ChildModel child}) {
    selectedChild = child;
  }
}
