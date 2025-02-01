import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'child.g.dart';

class ChildStore extends _ChildStore with _$ChildStore {
  ChildStore({
    required super.apiClient,
    required super.userStore,
  });
}

abstract class _ChildStore with Store {
  _ChildStore({
    required this.apiClient,
    required this.userStore,
  });

  final ApiClient apiClient;
  final UserStore userStore;

  void add({
    required ChildModel model,
    // required String name,
    // required double weight,
    // required double height,
    // required double headCirc,
  }) {
    apiClient
        .post(
      '${Endpoint.child}/', body: model.toJson(),

      // {
      //   'first_name': name,
      //   'weight': weight,
      //   'height': height,
      //   'head_circ': headCirc,
      // }
    )
        .then((v) {
      userStore.children.add(model);
    });
  }

  void update({required ChildModel model}) {
    apiClient.patch('${Endpoint.child}/', body: model.toJson()).then((v) {
      model.setIsChanged(false);
      userStore.children
          .firstWhere((v) => v.id == model.id)
          .setIsChanged(false);
    });
  }

  void updateAvatar({required XFile file, required ChildModel model}) {
    FormData formData = FormData.fromMap({
      'child_id': model.id,
      'avatar': MultipartFile.fromFileSync(file.path, filename: file.name),
    });

    apiClient.put('${Endpoint().childAvatar}/', body: formData).then((v) {
      userStore.children.firstWhere((v) => v.id == model.id).setAvatar(
          '${const AppConfig().apiUrl}${Endpoint.avatar}/${v?['avatar']}');
    });
  }

  void deleteAvatar({required String id}) {
    apiClient.delete(Endpoint().childAvatar, body: {
      'child_id': id,
    });
  }

  @action
  void delete({required String id}) {
    apiClient.delete('${Endpoint.child}/', body: {'child_id': id}).then((v) {
      userStore.children.removeWhere((element) => element.id == id);
    });
  }
}
