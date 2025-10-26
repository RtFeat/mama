import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'growth_store_table.g.dart';

class GrowthTableStore extends _GrowthTableStore with _$GrowthTableStore {
  GrowthTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.store,
  });
}

abstract class _GrowthTableStore extends TableStore<EntityHistoryHeight>
    with Store {
  _GrowthTableStore({
    required super.apiClient,
    required super.faker,
    required this.store,
    required this.restClient,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryHeight();
          },
          basePath: 'growth/height/history',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryHeight.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryHeight>[],
            };
          },
        ) {
    _setupChildIdReaction();
  }
  
  final RestClient restClient;
  final GrowthStore store;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => store.userStore.selectedChild?.id ?? '';

  @observable
  String sortOrder = 'new'; // 'new' or 'old'

  @observable
  GrowthUnit growthUnit = GrowthUnit.cm; // 'cm' or 'm'

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
  void setGrowthUnit(GrowthUnit unit) {
    if (!_isActive) return;
    growthUnit = unit;
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
        'Рост',
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
  void showAddRecordDialog(BuildContext context, int index, List<EntityHistoryHeight> sortedList) {
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
            title: 'Рост',
            currentWeek: '${_formatWeeks(currentEntity.weeks)} неделя',
            previousWeek: prevEntity?.data ?? '',
            selectedWeek: currentEntity.data ?? '',
            nextWeek: nextEntity?.data ?? '',
            weight: '${currentEntity.height} см',
            weightStatus: currentEntity.normal ?? '',
            weightStatusColor: currentEntity.normal == 'Граница нормы'
                ? AppColors.greenLightTextColor
                : AppColors.orangeTextColor,
            medianWeight: '234',
            normWeightRange: '243-234',
            weightToGain: '234',
            note: currentEntity.notes,
            onEdit: () {
              if (!_isActive || !builderContext.mounted) return;
              Navigator.of(builderContext).pop();
              if (context.mounted) {
                router.pushNamed(AppViews.addGrowthView, extra: {
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
                await restClient.growth.deleteGrowthHeightDeleteStats(
                    dto: GrowthDeleteHeightDto(id: currentEntity.id));
                
                // Проверяем состояние перед обновлением UI
                if (_isActive && builderContext.mounted) {
                  Navigator.of(builderContext).pop();
                  
                  // Обновляем данные только если контексты активны
                  if (context.mounted) {
                    store.fetchGrowthDetails();
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
                await restClient.growth.deleteGrowthHeightDeleteNotes(
                    dto: GrowthDeleteHeightDto(id: currentEntity.id));
                
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
                  'onSaved': (value) {
                    if (!_isActive) return;
                    if (value != currentEntity.notes) {
                      restClient.growth.patchGrowthHeightNotes(
                          dto: GrowthChangeNotesHeightDto(
                        id: currentEntity.id,
                        notes: value,
                      ));
                      refresh();
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

    final sortedList = List<EntityHistoryHeight>.from(listData);
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

      final heightValue = double.tryParse(entity.height ?? '') ?? 0.0;
      final displayHeight = growthUnit == GrowthUnit.m
          ? (heightValue / 100).toStringAsFixed(2)
          : entity.height;

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
          title: displayHeight,
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
