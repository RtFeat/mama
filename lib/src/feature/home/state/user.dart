import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/models/growth_insert_height_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_weight_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_circle_dto.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'user.g.dart';

class UserStore<UserData> extends _UserStore with _$UserStore {
  UserStore({
    required super.apiClient,
    required super.verifyStore,
    required super.faker,
    required super.chatsViewStore,
    required super.restClient,
  });
}

abstract class _UserStore extends SingleDataStore<UserData> with Store {
  final VerifyStore verifyStore;
  final ChatsViewStore chatsViewStore;
  final RestClient restClient;
  ChildStore? _childStore;
  
  _UserStore({
    required super.apiClient,
    required this.verifyStore,
    required super.faker,
    required this.chatsViewStore,
    required this.restClient,
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
      
      // Сохраняем данные роста для детей, у которых есть данные о весе, росте и голове
      // но они еще не сохранены в разделе "Развитие"
      _saveGrowthDataForChildren();
    }
    this.data = data;
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
      children.where((element) => element.isChanged).forEach((element) {
        chatsViewStore.groups.resetPagination();
        chatsViewStore.loadAllGroups(element.id);
      });
    });
  }

  /// Уведомляет все хранилища роста о необходимости обновления данных
  @action
  void notifyGrowthStoresRefresh(String childId) {
    // Этот метод будет вызываться из ChildStore после создания ребенка
    // для принудительного обновления всех хранилищ роста
    print('UserStore: Уведомление об обновлении хранилищ роста для childId: $childId');
    
    // Устанавливаем флаг для принудительного обновления хранилищ роста
    // Это будет использоваться в виджетах для принудительного обновления
    _forceRefreshGrowthStores = true;
    _lastRefreshChildId = childId;
  }

  /// Флаг для принудительного обновления хранилищ роста
  bool _forceRefreshGrowthStores = false;
  String? _lastRefreshChildId;

  /// Проверяет, нужно ли принудительно обновить хранилища роста
  bool shouldRefreshGrowthStores(String childId) {
    if (_forceRefreshGrowthStores && _lastRefreshChildId == childId) {
      _forceRefreshGrowthStores = false;
      _lastRefreshChildId = null;
      return true;
    }
    return false;
  }

  /// Устанавливает ChildStore для доступа к методам сохранения данных роста
  void setChildStore(ChildStore childStore) {
    _childStore = childStore;
  }

  /// Сохраняет данные роста для всех детей, у которых есть данные о весе, росте и голове
  /// но они еще не сохранены в разделе "Развитие"
  void _saveGrowthDataForChildren() async {
    if (children.isEmpty) return;
    
    logger.info('Проверяем детей на наличие данных роста для сохранения в раздел "Развитие"');
    
    for (final child in children) {
      if (child.id != null && (child.weight != null || child.height != null || child.headCircumference != null)) {
        logger.info('Найден ребенок с данными роста: ${child.firstName} (${child.id})');
        logger.info('Данные: weight=${child.weight}, height=${child.height}, headCircumference=${child.headCircumference}');
        
        // Сохраняем данные роста для этого ребенка
        await _saveChildGrowthData(child);
      }
    }
  }

  /// Сохраняет данные роста ребенка в трекер "Развитие"
  Future<void> _saveChildGrowthData(ChildModel child) async {
    try {
      // Сохраняем вес
      if (child.weight != null && child.id != null) {
        final childId = child.id!; // Явно приводим к String
        // Сначала проверяем историю веса
        final weightHistory = await restClient.growth.getGrowthWeightHistory(childId: childId);
        final existingWeights = weightHistory.list ?? [];
        
        // Проверяем, есть ли уже запись с таким весом
        final weightExists = existingWeights.any((record) => 
          record.weight == child.weight.toString()
        );
        
        if (weightExists) {
          logger.info('Запись о весе для ребенка ${child.firstName} уже существует, пропускаем');
        } else {
          String? formatCreatedAt(DateTime? dt) {
            if (dt == null) return null;
            final d = dt.toLocal();
            String two(int v) => v.toString().padLeft(2, '0');
            String three(int v) => v.toString().padLeft(3, '0');
            return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
          }
          
          final weightDto = GrowthInsertWeightDto(
            childId: childId,
            weight: child.weight.toString(),
            notes: null,
            createdAt: formatCreatedAt(child.birthDate),
          );
          
          await restClient.growth.postGrowthWeight(dto: weightDto);
          logger.info('Сохранен вес для ребенка ${child.firstName}: ${child.weight}');
        }
      }
      
      // Сохраняем рост
      if (child.height != null && child.id != null) {
        final childId = child.id!; // Явно приводим к String
        // Сначала проверяем историю роста
        final heightHistory = await restClient.growth.getGrowthHeightHistory(childId: childId);
        final existingHeights = heightHistory.list ?? [];
        
        // Проверяем, есть ли уже запись с таким ростом
        final heightExists = existingHeights.any((record) => 
          record.height == child.height.toString()
        );
        
        if (heightExists) {
          logger.info('Запись о росте для ребенка ${child.firstName} уже существует, пропускаем');
        } else {
          String? formatCreatedAt(DateTime? dt) {
            if (dt == null) return null;
            final d = dt.toLocal();
            String two(int v) => v.toString().padLeft(2, '0');
            String three(int v) => v.toString().padLeft(3, '0');
            return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
          }
          
          final heightDto = GrowthInsertHeightDto(
            childId: childId,
            height: child.height.toString(),
            notes: null,
            createdAt: formatCreatedAt(child.birthDate),
          );
          
          await restClient.growth.postGrowthHeight(dto: heightDto);
          logger.info('Сохранен рост для ребенка ${child.firstName}: ${child.height}');
        }
      }
      
      // Сохраняем окружность головы
      if (child.headCircumference != null && child.id != null) {
        final childId = child.id!; // Явно приводим к String
        // Сначала проверяем историю окружности головы
        final circleHistory = await restClient.growth.getGrowthCircleHistory(childId: childId);
        final existingCircles = circleHistory.list ?? [];
        
        // Проверяем, есть ли уже запись с такой окружностью головы
        final circleExists = existingCircles.any((record) => 
          record.circle == child.headCircumference.toString()
        );
        
        if (circleExists) {
          logger.info('Запись об окружности головы для ребенка ${child.firstName} уже существует, пропускаем');
        } else {
          String? formatCreatedAt(DateTime? dt) {
            if (dt == null) return null;
            final d = dt.toLocal();
            String two(int v) => v.toString().padLeft(2, '0');
            String three(int v) => v.toString().padLeft(3, '0');
            return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
          }
          
          final circleDto = GrowthInsertCircleDto(
            childId: childId,
            circle: child.headCircumference.toString(),
            notes: null,
            createdAt: formatCreatedAt(child.birthDate),
          );
          
          await restClient.growth.postGrowthCircle(dto: circleDto);
          logger.info('Сохранена окружность головы для ребенка ${child.firstName}: ${child.headCircumference}');
        }
      }
    } catch (e) {
      logger.error('Ошибка при сохранении данных роста для ребенка ${child.firstName}: $e');
    }
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
