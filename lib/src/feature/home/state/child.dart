import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/models/growth_insert_height_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_weight_dto.dart';
import 'package:mama/src/core/api/models/growth_insert_circle_dto.dart';
import 'package:mama/src/core/api/models/growth_change_stats_weight_dto.dart';
import 'package:mama/src/core/api/models/growth_change_stats_height_dto.dart';
import 'package:mama/src/core/api/models/growth_change_stats_circle_dto.dart';
import 'package:mama/src/core/api/models/growth_delete_weight_dto.dart';
import 'package:mama/src/core/api/models/growth_delete_circle_dto.dart';
import 'package:mama/src/core/api/models/entity_weight.dart';
import 'package:mama/src/core/api/models/entity_height.dart';
import 'package:mama/src/core/api/models/entity_circle.dart';
import 'package:mama/src/feature/trackers/models/evolution/height/growth_delete_height_dto.dart';
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

  void update({required ChildModel model}) async {
    final childId = model.id;
    final newBirthDate = model.birthDate;
    
    // Получаем старую дату рождения из модели (сохранена в setBirthDate)
    // Если не сохранена, пытаемся получить из локального хранилища
    DateTime? oldBirthDate = model.previousBirthDate;
    if (oldBirthDate == null) {
      try {
        final oldChild = userStore.children.firstWhere(
          (v) => v.id == model.id,
          orElse: () => model,
        );
        oldBirthDate = oldChild.birthDate;
      } catch (e) {
        logger.warning('Не удалось получить старую дату рождения из локального хранилища: $e');
      }
    }
    
    // Сравниваем даты, нормализуя их (только дата, без времени)
    bool birthDateChanged = false;
    if (oldBirthDate != null && newBirthDate != null) {
      final oldDate = DateTime(oldBirthDate.year, oldBirthDate.month, oldBirthDate.day);
      final newDate = DateTime(newBirthDate.year, newBirthDate.month, newBirthDate.day);
      birthDateChanged = oldDate != newDate;
    }
    
    logger.info('Обновление профиля ребенка: oldBirthDate=$oldBirthDate, newBirthDate=$newBirthDate, changed=$birthDateChanged');
    
    await apiClient.patch('${Endpoint.child}/', body: model.toJson()).then((v) {
      model.setIsChanged(false);
      userStore.children
          .firstWhere((v) => v.id == model.id)
          .setIsChanged(false);
    });
    
    // Сохраняем данные роста в трекер "Развитие" после обновления профиля
    if (childId != null) {
      try {
        // Если изменилась дата рождения, обновляем даты первых записей
        if (birthDateChanged && newBirthDate != null) {
          logger.info('Дата рождения изменилась, обновляем даты первых записей');
          await _updateFirstRecordsDates(childId: childId, newBirthDate: newBirthDate);
        } else {
          logger.info('Дата рождения не изменилась или равна null, пропускаем обновление записей');
        }
        
        // Сохраняем вес
        if (model.weight != null) {
          try {
            // Проверяем историю веса
            final weightHistory = await restClient.growth.getGrowthWeightHistory(childId: childId);
            final existingWeights = weightHistory.list ?? [];
            
            // Проверяем, есть ли уже запись с таким весом
            final weightExists = existingWeights.any((record) => 
              record.weight == model.weight.toString()
            );
            
            if (!weightExists) {
              final weightDto = GrowthInsertWeightDto(
                childId: childId,
                weight: model.weight.toString(),
                notes: null,
                createdAt: _formatBirthDateWithOffset(model.birthDate),
              );
              
              await restClient.growth.postGrowthWeight(dto: weightDto);
              logger.info('Сохранен вес для ребенка ${model.firstName}: ${model.weight}');
            }
          } catch (e) {
            logger.error('Ошибка при сохранении веса: $e');
          }
        }
        
        // Сохраняем рост
        if (model.height != null) {
          try {
            // Проверяем историю роста
            final heightHistory = await restClient.growth.getGrowthHeightHistory(childId: childId);
            final existingHeights = heightHistory.list ?? [];
            
            // Проверяем, есть ли уже запись с таким ростом
            final heightExists = existingHeights.any((record) => 
              record.height == model.height.toString()
            );
            
            if (!heightExists) {
              final heightDto = GrowthInsertHeightDto(
                childId: childId,
                height: model.height.toString(),
                notes: null,
                createdAt: _formatBirthDateWithOffset(model.birthDate),
              );
              
              await restClient.growth.postGrowthHeight(dto: heightDto);
              logger.info('Сохранен рост для ребенка ${model.firstName}: ${model.height}');
            }
          } catch (e) {
            logger.error('Ошибка при сохранении роста: $e');
          }
        }
        
        // Сохраняем окружность головы
        if (model.headCircumference != null) {
          try {
            // Проверяем историю окружности головы
            final circleHistory = await restClient.growth.getGrowthCircleHistory(childId: childId);
            final existingCircles = circleHistory.list ?? [];
            
            // Проверяем, есть ли уже запись с такой окружностью головы
            final circleExists = existingCircles.any((record) => 
              record.circle == model.headCircumference.toString()
            );
            
            if (!circleExists) {
              final circleDto = GrowthInsertCircleDto(
                childId: childId,
                circle: model.headCircumference.toString(),
                notes: null,
                createdAt: _formatBirthDateWithOffset(model.birthDate),
              );
              
              await restClient.growth.postGrowthCircle(dto: circleDto);
              logger.info('Сохранена окружность головы для ребенка ${model.firstName}: ${model.headCircumference}');
            }
          } catch (e) {
            logger.error('Ошибка при сохранении окружности головы: $e');
          }
        }
        
        // Обновляем хранилища роста для немедленного отображения данных
        logger.info('Начинаем принудительное обновление хранилищ роста для childId: $childId');
        _forceRefreshGrowthStores(childId);
        
        // Дополнительно: принудительно активируем stores и загружаем данные
        Future.delayed(Duration(milliseconds: 500), () {
          logger.info('Дополнительная попытка загрузки данных через 500ms');
          _forceRefreshGrowthStores(childId);
        });
      } catch (e) {
        logger.error('Ошибка при сохранении данных роста для ребенка ${model.firstName}: $e');
      }
    }
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

  String _formatCurrentDateTime() {
    final d = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    String three(int v) => v.toString().padLeft(3, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
  }

  /// Форматирует дату рождения с небольшим смещением (1 час), чтобы новая запись
  /// была позже регистрационной, но все еще в тот же день рождения
  String? _formatBirthDateWithOffset(DateTime? birthDate) {
    if (birthDate == null) return null;
    // Добавляем 1 час к дате рождения, чтобы новая запись была позже регистрационной
    final d = birthDate.toLocal().add(const Duration(hours: 1));
    String two(int v) => v.toString().padLeft(2, '0');
    String three(int v) => v.toString().padLeft(3, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
  }

  /// Обновляет даты первых записей (вес, рост, окружность головы) на новую дату рождения
  Future<void> _updateFirstRecordsDates({
    required String childId,
    required DateTime newBirthDate,
  }) async {
    try {
      logger.info('Обновление дат первых записей для childId: $childId, новая дата рождения: $newBirthDate');
      
      // Форматируем дату в формате ISO8601 UTC для PATCH запросов
      final newBirthDateUtc = newBirthDate.toUtc().toIso8601String();
      
      // Форматируем дату в формате с пробелом для POST запросов
      String formatCreatedAtForPost(DateTime dt) {
        final d = dt.toLocal();
        String two(int v) => v.toString().padLeft(2, '0');
        String three(int v) => v.toString().padLeft(3, '0');
        return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}.${three(d.millisecond)}';
      }
      final newBirthDateForPost = formatCreatedAtForPost(newBirthDate);
      
      // Обновляем первую запись веса
      try {
        logger.info('Получение истории веса для childId: $childId');
        final weightHistory = await restClient.growth.getGrowthWeightHistory(childId: childId);
        final weights = weightHistory.list ?? [];
        logger.info('Найдено записей веса: ${weights.length}');
        if (weights.isNotEmpty) {
          // Сортируем по дате (самая старая первая)
          weights.sort((a, b) {
            final dateA = a.allData ?? '';
            final dateB = b.allData ?? '';
            return dateA.compareTo(dateB);
          });
          
          final firstWeight = weights.first;
          if (firstWeight.id != null && firstWeight.weight != null) {
            // Пытаемся обновить через PATCH, при ошибке 500 удаляем и создаем заново
            try {
              final weightDto = GrowthChangeStatsWeightDto(
                stats: EntityWeight(
                  id: firstWeight.id,
                  childId: childId,
                  weight: firstWeight.weight,
                  notes: firstWeight.notes ?? '',
                  createdAt: newBirthDateUtc,
                ),
              );
              
              logger.info('Отправка запроса на обновление даты веса: id=${firstWeight.id}, weight=${firstWeight.weight}, newDate=$newBirthDateUtc');
              await restClient.growth.patchGrowthWeightStats(dto: weightDto);
              logger.info('✅ Обновлена дата первой записи веса: ${firstWeight.weight} на дату $newBirthDateUtc');
            } on DioException catch (e) {
              // Если ошибка 500 (проблема на сервере), удаляем и создаем заново
              if (e.response?.statusCode == 500) {
                logger.warning('PATCH не удался (ошибка 500), удаляем и создаем заново');
                try {
                  // Удаляем старую запись
                  await restClient.growth.deleteGrowthWeightDeleteStats(
                    dto: GrowthDeleteWeightDto(id: firstWeight.id),
                  );
                  logger.info('Удалена старая запись веса: ${firstWeight.id}');
                  
                  // Создаем новую запись с правильной датой
                  final weightDto = GrowthInsertWeightDto(
                    childId: childId,
                    weight: firstWeight.weight,
                    notes: firstWeight.notes ?? '',
                    createdAt: newBirthDateForPost,
                  );
                  await restClient.growth.postGrowthWeight(dto: weightDto);
                  logger.info('✅ Создана новая запись веса: ${firstWeight.weight} на дату $newBirthDateForPost');
                } catch (e2) {
                  logger.error('❌ Ошибка при удалении/создании записи веса: $e2');
                }
              } else {
                logger.error('❌ Ошибка при обновлении даты первой записи веса: $e');
              }
            } catch (e) {
              logger.error('❌ Ошибка при обновлении даты первой записи веса: $e');
            }
          }
        }
      } catch (e) {
        logger.error('Ошибка при получении истории веса для обновления даты: $e');
      }
      
      // Обновляем первую запись роста
      try {
        logger.info('Получение истории роста для childId: $childId');
        final heightHistory = await restClient.growth.getGrowthHeightHistory(childId: childId);
        final heights = heightHistory.list ?? [];
        logger.info('Найдено записей роста: ${heights.length}');
        if (heights.isNotEmpty) {
          // Сортируем по дате (самая старая первая)
          heights.sort((a, b) {
            final dateA = a.allData ?? '';
            final dateB = b.allData ?? '';
            return dateA.compareTo(dateB);
          });
          
          final firstHeight = heights.first;
          if (firstHeight.id != null && firstHeight.height != null) {
            // Пытаемся обновить через PATCH, при ошибке 500 удаляем и создаем заново
            try {
              final heightEntity = EntityHeight(
                id: firstHeight.id,
                childId: childId,
                height: firstHeight.height,
                notes: firstHeight.notes ?? '',
                createdAt: newBirthDateUtc,
              );
              
              final heightDto = GrowthChangeStatsHeightDto(
                stats: heightEntity,
              );
              
              logger.info('Отправка запроса на обновление даты роста: id=${firstHeight.id}, height=${firstHeight.height}, newDate=$newBirthDateUtc');
              await restClient.growth.patchGrowthHeightStats(dto: heightDto);
              logger.info('✅ Обновлена дата первой записи роста: ${firstHeight.height} на дату $newBirthDateUtc');
            } on DioException catch (e) {
              // Если ошибка 500 (проблема на сервере), удаляем и создаем заново
              if (e.response?.statusCode == 500) {
                logger.warning('PATCH не удался (ошибка 500), удаляем и создаем заново');
                try {
                  // Удаляем старую запись
                  await restClient.growth.deleteGrowthHeightDeleteStats(
                    dto: GrowthDeleteHeightDto(id: firstHeight.id),
                  );
                  logger.info('Удалена старая запись роста: ${firstHeight.id}');
                  
                  // Создаем новую запись с правильной датой
                  final heightDto = GrowthInsertHeightDto(
                    childId: childId,
                    height: firstHeight.height,
                    notes: firstHeight.notes ?? '',
                    createdAt: newBirthDateForPost,
                  );
                  await restClient.growth.postGrowthHeight(dto: heightDto);
                  logger.info('✅ Создана новая запись роста: ${firstHeight.height} на дату $newBirthDateForPost');
                } catch (e2) {
                  logger.error('❌ Ошибка при удалении/создании записи роста: $e2');
                }
              } else {
                logger.error('❌ Ошибка при обновлении даты первой записи роста: $e');
              }
            } catch (e) {
              logger.error('❌ Ошибка при обновлении даты первой записи роста: $e');
            }
          }
        }
      } catch (e) {
        logger.error('Ошибка при получении истории роста для обновления даты: $e');
      }
      
      // Обновляем первую запись окружности головы
      try {
        logger.info('Получение истории окружности головы для childId: $childId');
        final circleHistory = await restClient.growth.getGrowthCircleHistory(childId: childId);
        final circles = circleHistory.list ?? [];
        logger.info('Найдено записей окружности головы: ${circles.length}');
        if (circles.isNotEmpty) {
          // Сортируем по дате (самая старая первая)
          circles.sort((a, b) {
            final dateA = a.allData ?? '';
            final dateB = b.allData ?? '';
            return dateA.compareTo(dateB);
          });
          
          final firstCircle = circles.first;
          if (firstCircle.id != null && firstCircle.circle != null) {
            // Пытаемся обновить через PATCH, при ошибке 500 удаляем и создаем заново
            try {
              final circleDto = GrowthChangeStatsCircleDto(
                stats: EntityCircle(
                  id: firstCircle.id,
                  childId: childId,
                  circle: firstCircle.circle,
                  notes: firstCircle.notes ?? '',
                  createdAt: newBirthDateUtc,
                ),
              );
              
              logger.info('Отправка запроса на обновление даты окружности головы: id=${firstCircle.id}, circle=${firstCircle.circle}, newDate=$newBirthDateUtc');
              await restClient.growth.patchGrowthCircleStats(dto: circleDto);
              logger.info('✅ Обновлена дата первой записи окружности головы: ${firstCircle.circle} на дату $newBirthDateUtc');
            } on DioException catch (e) {
              // Если ошибка 500 (проблема на сервере), удаляем и создаем заново
              if (e.response?.statusCode == 500) {
                logger.warning('PATCH не удался (ошибка 500), удаляем и создаем заново');
                try {
                  // Удаляем старую запись
                  await restClient.growth.deleteGrowthCircleDeleteStats(
                    dto: GrowthDeleteCircleDto(id: firstCircle.id),
                  );
                  logger.info('Удалена старая запись окружности головы: ${firstCircle.id}');
                  
                  // Создаем новую запись с правильной датой
                  final circleDto = GrowthInsertCircleDto(
                    childId: childId,
                    circle: firstCircle.circle,
                    notes: firstCircle.notes ?? '',
                    createdAt: newBirthDateForPost,
                  );
                  await restClient.growth.postGrowthCircle(dto: circleDto);
                  logger.info('✅ Создана новая запись окружности головы: ${firstCircle.circle} на дату $newBirthDateForPost');
                } catch (e2) {
                  logger.error('❌ Ошибка при удалении/создании записи окружности головы: $e2');
                }
              } else {
                logger.error('❌ Ошибка при обновлении даты первой записи окружности головы: $e');
              }
            } catch (e) {
              logger.error('❌ Ошибка при обновлении даты первой записи окружности головы: $e');
            }
          }
        }
      } catch (e) {
        logger.error('Ошибка при получении истории окружности головы для обновления даты: $e');
      }
    } catch (e) {
      logger.error('Ошибка при обновлении дат первых записей: $e');
    }
  }
}
