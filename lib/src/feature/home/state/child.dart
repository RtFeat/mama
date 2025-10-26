import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/models/growth_insert_height_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_weight_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_circle_dto.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'child.g.dart';

class ChildStore extends _ChildStore with _$ChildStore {
  ChildStore({
    required super.apiClient,
    required super.userStore,
    required super.restClient,
  });
}

abstract class _ChildStore with Store {
  _ChildStore({
    required this.apiClient,
    required this.userStore,
    required this.restClient,
  });

  final ApiClient apiClient;
  final UserStore userStore;
  final RestClient restClient;

  void add({
    required ChildModel model,
    // required String name,
    // required double weight,
    // required double height,
    // required double headCirc,
  }) async {
    final response = await apiClient.post(
      '${Endpoint.child}/',
      body: model.toJson(),
    );
    
    // Получаем ID созданного ребенка из ответа
    final childId = response?['id'] as String? ?? model.id;
    
    // Сохраняем данные роста в трекер "Развитие"
        if (model.weight != null && childId != null) {
          try {
            String? formatCreatedAt(DateTime? dt) {
              if (dt == null) return null;
              final d = dt.toLocal();
              String two(int v) => v.toString().padLeft(2, '0');
              String three(int v) => v.toString().padLeft(3, '0');
              return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
            }
            
            final weightDto = GrowthInsertWeightDto(
              childId: childId,
              weight: model.weight.toString(),
              notes: null,
              createdAt: formatCreatedAt(model.birthDate),
            );
            
            // Используем тот же restClient, что и при добавлении веса
            await restClient.growth.postGrowthWeight(dto: weightDto);
          } catch (e) {
            logger.error('Ошибка при сохранении веса: $e');
          }
        }
    
    if (model.height != null && childId != null) {
      try {
        String? formatCreatedAt(DateTime? dt) {
          if (dt == null) return null;
          final d = dt.toLocal();
          String two(int v) => v.toString().padLeft(2, '0');
          String three(int v) => v.toString().padLeft(3, '0');
          return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
        }
        
        final heightDto = GrowthInsertHeightDto(
          childId: childId,
          height: model.height.toString(),
          notes: null,
          createdAt: formatCreatedAt(model.birthDate),
        );
        
        // Используем тот же restClient, что и при добавлении роста
        await restClient.growth.postGrowthHeight(dto: heightDto);
      } catch (e) {
        logger.error('Ошибка при сохранении роста: $e');
      }
    }
    
    if (model.headCircumference != null && childId != null) {
      try {
        String? formatCreatedAt(DateTime? dt) {
          if (dt == null) return null;
          final d = dt.toLocal();
          String two(int v) => v.toString().padLeft(2, '0');
          String three(int v) => v.toString().padLeft(3, '0');
          return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
        }
        
        final circleDto = GrowthInsertCircleDto(
          childId: childId,
          circle: model.headCircumference.toString(),
          notes: null,
          createdAt: formatCreatedAt(model.birthDate),
        );
        
        // Используем тот же restClient, что и при добавлении окружности головы
        await restClient.growth.postGrowthCircle(dto: circleDto);
      } catch (e) {
        logger.error('Ошибка при сохранении окружности головы: $e');
      }
    }
    
    // Создаем новый ChildModel с правильным id из сервера
    final childWithId = childId != null 
        ? ChildModel(
            id: childId,
            firstName: model.firstName,
            secondName: model.secondName,
            gender: model.gender,
            isTwins: model.isTwins,
            childbirth: model.childbirth,
            childBirthWithComplications: model.childBirthWithComplications,
            birthDate: model.birthDate,
            height: model.height,
            weight: model.weight,
            headCircumference: model.headCircumference,
            about: model.about,
            avatarUrl: model.avatarUrl,
            status: model.status,
            updatedAt: model.updatedAt,
            createdAt: model.createdAt,
          )
        : model;
    
    userStore.children.add(childWithId);
    
    // Устанавливаем созданного ребенка как выбранного
    userStore.selectedChild = childWithId;
    logger.info('Установлен созданный ребенок как выбранный: ${childWithId.firstName} (${childWithId.id})');
    
    // Обновляем хранилища роста для немедленного отображения данных
    if (childId != null) {
      logger.info('Начинаем принудительное обновление хранилищ роста для childId: $childId');
      _forceRefreshGrowthStores(childId);
      
      // Дополнительно: принудительно активируем stores и загружаем данные
      Future.delayed(Duration(milliseconds: 500), () {
        logger.info('Дополнительная попытка загрузки данных через 500ms');
        _forceRefreshGrowthStores(childId);
      });
    }
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

  /// Принудительно обновляет все хранилища роста для мгновенного отображения данных
  void _forceRefreshGrowthStores(String childId) {
    try {
      logger.info('=== _forceRefreshGrowthStores START ===');
      logger.info('childId: $childId');
      logger.info('userStore.selectedChild: ${userStore.selectedChild?.firstName} (${userStore.selectedChild?.id})');
      
      // Устанавливаем флаг обновления в UserStore для уведомления всех подписчиков
      userStore.notifyGrowthStoresRefresh(childId);

      logger.info('Принудительное обновление хранилищ роста для childId: $childId');
      logger.info('Текущий selectedChild: ${userStore.selectedChild?.firstName} (${userStore.selectedChild?.id})');

      // Дополнительно: принудительно обновляем selectedChild для триггера реакций
      // Это заставит все хранилища роста обновиться через их реакции на изменение childId
      final currentChild = userStore.selectedChild;
      if (currentChild != null && currentChild.id == childId) {
        logger.info('Триггер реакций: selectedChild уже установлен правильно');
        // Временно сбрасываем и восстанавливаем selectedChild для триггера реакций
        userStore.selectedChild = null;
        Future.delayed(Duration(milliseconds: 100), () {
          userStore.selectedChild = currentChild;
          logger.info('Триггер реакций: selectedChild восстановлен');
        });
      } else {
        logger.warning('Триггер реакций: selectedChild не установлен или не совпадает с childId');
        // Попробуем найти и установить правильного ребенка
        try {
          final child = userStore.children.firstWhere(
            (c) => c.id == childId,
          );
          userStore.selectedChild = child;
          logger.info('Триггер реакций: selectedChild установлен вручную');
        } catch (e) {
          logger.warning('Триггер реакций: ребенок с childId $childId не найден в списке');
        }
      }
    } catch (e) {
      logger.error('Ошибка при принудительном обновлении хранилищ роста: $e');
    }
    
    logger.info('=== _forceRefreshGrowthStores END ===');
  }
}
