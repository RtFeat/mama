import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'weight_store_table.g.dart';

class WeightTableStore extends _WeightTableStore with _$WeightTableStore {
  WeightTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.store,
  });
}

abstract class _WeightTableStore extends TableStore<EntityHistoryWeight>
    with Store {
  _WeightTableStore({
    required super.apiClient,
    required super.faker,
    required this.store,
    required this.restClient,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryWeight();
          },
          basePath: 'growth/weight/history',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryWeight.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryWeight>[],
            };
          },
        ) {
    _setupChildIdReaction();
  }
  
  final RestClient restClient;
  final WeightStore store;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => store.userStore.selectedChild?.id ?? '';

  @observable
  String sortOrder = 'new'; // 'new' or 'old'

  @observable
  WeightUnit weightUnit = WeightUnit.kg; // 'kg' or 'g'

  @observable
  bool showAll = false; // Показывать все записи или только первые

  // Добавляем флаг для отслеживания активного состояния
  @observable
  bool _isActive = true;

  static const int _initialRowLimit = 6; // Количество записей по умолчанию

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    // Используем новый метод refreshForChild для полной перезагрузки
    refreshForChild(childId);
  }

  @action
  void deactivate() {
    _isActive = false;
    _childIdReaction?.call();
    _childIdReaction = null;
  }

  @action
  void activate() {
    _isActive = true;
    if (_childIdReaction == null) {
      _setupChildIdReaction();
    }
    // Загружаем данные при активации только если есть childId и данные еще не загружены
    if (childId.isNotEmpty && listData.isEmpty) {
      _loadDataForChild(childId);
    }
  }

  @action
  void setSortOrder(int index) {
    if (!_isActive) return;
    sortOrder = index == 0 ? 'new' : 'old';
  }

  @action
  void setWeightUnit(WeightUnit unit) {
    if (!_isActive) return;
    weightUnit = unit;
  }

  @action
  void toggleShowAll() {
    if (!_isActive) return;
    showAll = !showAll;
  }

  @action
  Future<void> refreshForChild(String childId) async {
    if (!_isActive || childId.isEmpty) return;
    
    // Сбрасываем все данные
    runInAction(() {
      listData.clear();
      currentPage = 1;
      hasMore = true;
      showAll = false;
    });
    
    // Загружаем первую страницу
    await loadPage(
      newFilters: [
        SkitFilter(
          field: 'child_id', 
          operator: FilterOperator.equals,
          value: childId,
        ),
      ],
    );
  }

  @computed
  int get totalRecordsCount => listData.length;

  @computed
  int get shownRecordsCount {
    if (showAll) return totalRecordsCount;
    return totalRecordsCount > _initialRowLimit ? _initialRowLimit : totalRecordsCount;
  }

  @computed
  bool get canShowAll => !showAll && totalRecordsCount > _initialRowLimit;

  @computed
  bool get canCollapse => showAll;

  /// Форматирует значение недели, убирая минус если он есть
  String _formatWeeks(String? weeks) {
    if (weeks == null || weeks.isEmpty) return '0';
    
    // Убираем минус если он есть
    final cleanWeeks = weeks.startsWith('-') ? weeks.substring(1) : weeks;
    
    // Проверяем, что это число
    final weeksInt = int.tryParse(cleanWeeks);
    if (weeksInt == null) return '0';
    
    return weeksInt.toString();
  }

  @override
  TableData get tableData => TableData(
      headerTitle: '',
      columnHeaders: [
        'Дата',
        '',
        'Неделя',
        'Вес',
      ],
      columnWidths: {
        0: 3,
        1: 2,
        2: 1,
        3: 1,
      },
      rows: rows,
      cellDecoration: CellDecoration(
        headerStyle: AppTextStyles.f10w700.copyWith(
          color: AppColors.greyBrighterColor,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'SFProText',
        ),
      ));

  // ИСПРАВЛЯЕМ: передаем контекст как параметр вместо использования глобального navKey
  void showAddRecordDialog(BuildContext context, int index, List<EntityHistoryWeight> sortedList) {
    // Проверяем, что store активен и контекст валидный
    if (!_isActive || !context.mounted) return;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        return StatefulBuilder(builder: (builderContext, setState) {
          // Дополнительные проверки безопасности
          if (!_isActive || !context.mounted || !builderContext.mounted) {
            return const SizedBox.shrink();
          }

          final currentEntity = sortedList[index];
          final nextEntity =
              sortedList.length > index + 1 ? sortedList[index + 1] : null;
          final prevEntity = index > 0 ? sortedList[index - 1] : null;

          final data = MeasurementDetails(
            title: 'Вес',
            currentWeek: '${_formatWeeks(currentEntity.weeks)} неделя',
            previousWeek: prevEntity?.data ?? '',
            selectedWeek: currentEntity.data ?? '',
            nextWeek: nextEntity?.data ?? '',
            weight: '${currentEntity.weight} кг',
            weightStatus: currentEntity.normal ?? '',
            weightStatusColor: currentEntity.normal == 'Граница нормы'
                ? AppColors.greenLightTextColor
                : AppColors.orangeTextColor,
            medianWeight: '234',
            normWeightRange: '243-234',
            weightToGain: '234',
            note: currentEntity.notes,
            viewNormsLabel: 'Смотреть нормы веса',
            onViewNormsTap: () {
              router.pushNamed(AppViews.serviceKnowlegde);
            },
            onEdit: () {
              if (!_isActive || !builderContext.mounted) return;
              Navigator.of(builderContext).pop();
              if (context.mounted) {
                router.pushNamed(AppViews.addWeightView, extra: {
                  'entity': currentEntity,
                });
              }
            },
            onNextWeekTap: () {
              if (!_isActive || !builderContext.mounted) return;
              if (builderContext.mounted && index < sortedList.length - 1) {
                setState(() {
                  index++;
                });
              }
            },
            onPreviousWeekTap: () {
              if (!_isActive || !builderContext.mounted) return;
              if (builderContext.mounted && index > 0) {
                setState(() {
                  index--;
                });
              }
            },
            onDelete: () async {
              if (!_isActive || !builderContext.mounted) return;
              
              try {
                await restClient.growth.deleteGrowthWeightDeleteStats(
                    dto: GrowthDeleteWeightDto(id: currentEntity.id));
                
                // Проверяем состояние перед обновлением UI
                if (_isActive && builderContext.mounted) {
                  Navigator.of(builderContext).pop();
                  
                  // Обновляем данные только если контексты активны
                  if (context.mounted) {
                    store.fetchWeightDetails();
                    refresh();
                  }
                }
              } catch (e) {
                // Обрабатываем ошибку безопасно
                if (_isActive && builderContext.mounted) {
                  // Можно показать ошибку пользователю
                }
              }
            },
            onClose: () {
              if (builderContext.mounted) {
                Navigator.of(builderContext).pop();
              }
            },
            onNoteDelete: () async {
              if (!_isActive || !builderContext.mounted) return;
              
              try {
                await restClient.growth.deleteGrowthWeightDeleteNotes(
                    dto: GrowthDeleteWeightDto(id: currentEntity.id));
                
                if (_isActive && builderContext.mounted) {
                  currentEntity.notes = null;
                  setState(() {});
                  if (context.mounted) {
                    refresh();
                  }
                }
              } catch (error) {
                // Игнорируем ошибки если контексты неактивны
              }
            },
            onNoteEdit: () {
              if (!_isActive || !builderContext.mounted) return;
              
              Navigator.of(builderContext).pop();
              if (context.mounted) {
                router.pushNamed(AppViews.addNote, extra: {
                  'initialValue': currentEntity.notes,
                  'onSaved': (value) async {
                    if (!_isActive) return;
                    if (value != currentEntity.notes) {
                      await restClient.growth.patchGrowthWeightNotes(
                        dto: GrowthChangeNotesWeightDto(
                          id: currentEntity.id,
                          notes: value,
                        ),
                      );
                      // Обновляем локальную модель для мгновенной консистентности
                      currentEntity.notes = value;
                      // Обновляем UI диалога (если он ещё на экране)
                      if (builderContext.mounted) {
                        setState(() {});
                      }
                      // Обновляем детали и таблицу
                      if (context.mounted) {
                        await store.fetchWeightDetails();
                        await refresh();
                      }
                    }
                  },
                });
              }
            },
          );

          return MeasurementOverlay(details: data);
        });
      },
    );
  }

  @override
  @computed
  ObservableList<List<TableItem>> get rows {
    if (!_isActive) return ObservableList.of([]);
    
    final List<List<TableItem>> result = [];

    final sortedList = List<EntityHistoryWeight>.from(listData);
    sortedList.sort((a, b) {
      final dateStringA = a.allData ?? a.data ?? '';
      final dateStringB = b.allData ?? b.data ?? '';

      if (sortOrder == 'new') {
        return dateStringB.compareTo(dateStringA);
      } else {
        return dateStringA.compareTo(dateStringB);
      }
    });

    // Ограничиваем количество записей в зависимости от showAll
    final recordsToShow = showAll ? sortedList : sortedList.take(_initialRowLimit).toList();

    for (var i = 0; i < recordsToShow.length; i++) {
      final entity = recordsToShow[i];
      final bool hasNote = entity.notes != null && entity.notes!.isNotEmpty;

      final bool isBad = entity.normal == 'Вне нормы';
      final bool isNormal = entity.normal == 'Граница нормы';

      final decoration = (isBad || isNormal)
          ? CellDecoration(
              color: isBad
                  ? AppColors.yellowBackgroundColor
                  : AppColors.greenLighterBackgroundColor,
              radius: 8,
            )
          : null;

      final weightValue = double.tryParse(entity.weight ?? '') ?? 0.0;
      final displayWeight = weightUnit == WeightUnit.g
          ? (weightValue * 1000).toStringAsFixed(0)
          : entity.weight;

      result.add([
        TableItem(
          onTap: () {
            // Получаем контекст безопасно - НЕ используем navKey.currentContext!
            final context = router.routerDelegate.navigatorKey.currentContext;
            if (context != null && context.mounted && _isActive) {
              showAddRecordDialog(context, i, sortedList);
            }
          },
          title: entity.data.toString(),
          row: result.length + 1,
          column: 1,
          isHide: false,
          decoration: decoration,
          trailing: hasNote
              ? Row(
                  children: [
                    NoteIconWidget(
                      size: 20,
                    ),
                  ],
                )
              : null,
        ),
        TableItem(
          onTap: () {
            final context = router.routerDelegate.navigatorKey.currentContext;
            if (context != null && context.mounted && _isActive) {
              showAddRecordDialog(context, i, sortedList);
            }
          },
          title: entity.normal,
          row: result.length + 1,
          column: 2,
          trailing: const SizedBox(
            height: 20,
          ),
          decoration: decoration?.copyWith(
              textStyle: AppTextStyles.f10w700.copyWith(
            color: isBad
                ? AppColors.orangeTextColor
                : AppColors.greenLightTextColor,
          )),
        ),
        TableItem(
          onTap: () {
            final context = router.routerDelegate.navigatorKey.currentContext;
            if (context != null && context.mounted && _isActive) {
              showAddRecordDialog(context, i, sortedList);
            }
          },
          title: _formatWeeks(entity.weeks),
          row: result.length + 1,
          column: 2,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        TableItem(
          onTap: () {
            final context = router.routerDelegate.navigatorKey.currentContext;
            if (context != null && context.mounted && _isActive) {
              showAddRecordDialog(context, i, sortedList);
            }
          },
          title: displayWeight,
          row: result.length + 1,
          column: 3,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ]);
    }
    return ObservableList.of(result);
  }
}