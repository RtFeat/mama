import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mobx/mobx.dart';

export 'add_growth.dart';

class GrowthView extends StatelessWidget {
  const GrowthView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  // Флаг для отслеживания активности виджета
  bool _isActive = false;
  
  // Список для управления MobX reactions
  final List<ReactionDisposer> _disposers = [];
  
  // Убираем локальные переменные - используем Consumer для реактивности

  @override
  void initState() {
    super.initState();
    _isActive = true;
    
    // Инициализация stores
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isActive || !mounted) return;
      
      _initializeStores();
      _setupChildIdObserver();
    });
  }

  void _setupChildIdObserver() {
    if (!_isActive || !mounted) return;
    
    try {
      final userStore = context.read<UserStore>();
      
      // Добавляем reaction для отслеживания изменений childId
      final childIdReaction = reaction(
        (_) => userStore.selectedChild?.id,
        (String? newChildId) {
          if (_isActive && mounted && newChildId != null && newChildId.isNotEmpty) {
            // Принудительно обновляем UI при смене ребенка
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_isActive && mounted) {
                // Принудительно загружаем данные для нового ребенка
                try {
                  final growthStore = context.read<GrowthStore>();
                  final tableStore = context.read<GrowthTableStore>();
                  
                  // Очищаем и загружаем данные для нового ребенка
                  growthStore.fetchGrowthDetails();
                  
                  // Принудительно загружаем историю для таблицы
                  tableStore.refreshForChild(newChildId);
                  
                  // Дополнительно загружаем историю для GrowthStore
                  growthStore.loadPage(newFilters: [
                    SkitFilter(
                      field: 'child_id',
                      operator: FilterOperator.equals,
                      value: newChildId,
                    ),
                  ]);
                } catch (e) {
                  // Игнорируем ошибки
                }
                
                setState(() {});
              }
            });
          }
        },
      );
      
      _disposers.add(childIdReaction);
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  void _initializeStores() {
    if (!_isActive || !mounted) return;
    
    try {
      final growthStore = context.read<GrowthStore>();
      final tableStore = context.read<GrowthTableStore>();
      
      // Активируем stores
      growthStore.activate();
      tableStore.activate();
      
      final currentChildId = growthStore.childId;
      print('GrowthView _initializeStores: Current childId = $currentChildId');
      
      if (currentChildId.isNotEmpty) {
        // Загружаем данные роста
        growthStore.fetchGrowthDetails();
        
         // Явно загружаем данные таблицы
         tableStore.loadPage(
           newFilters: [
             SkitFilter(
               field: 'child_id',
               operator: FilterOperator.equals,
               value: currentChildId,
             ),
           ],
         ).then((_) {
           print('GrowthView: Table loaded with ${tableStore.listData.length} items');
         });
      }
      
      // Создаем безопасную асинхронную операцию
      _loadInfoSafely();
    } catch (e) {
      print('GrowthView _initializeStores error: $e');
    }
  }

  Future<void> _loadInfoSafely() async {
    if (!_isActive || !mounted) return;
    
    try {
      final growthStore = context.read<GrowthStore>();
      await growthStore.getIsShowInfo();
      if (_isActive && mounted) {
        setState(() {});
      }
    } catch (error) {
      if (_isActive && mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _setInfoSafely(bool value) async {
    if (!_isActive || !mounted) return;
    
    try {
      final growthStore = context.read<GrowthStore>();
      await growthStore.setIsShowInfo(value);
      if (_isActive && mounted) {
        setState(() {});
      }
    } catch (error) {
      if (_isActive && mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _isActive = false;
    
    // Деактивируем stores если они были инициализированы
    try {
      final growthStore = context.read<GrowthStore>();
      final tableStore = context.read<GrowthTableStore>();
      growthStore.deactivate();
      tableStore.deactivate();
    } catch (e) {
      // Игнорируем ошибки при деактивации
    }
    
    // Очищаем все MobX subscriptions
    for (final dispose in _disposers) {
      dispose();
    }
    _disposers.clear();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isActive || !mounted) {
      return const SizedBox.shrink();
    }

    final trackerType = EvolutionCategory.growth;

    // Используем Consumer вместо context.watch для большего контроля
    return Consumer2<GrowthStore, GrowthTableStore>(
      builder: (context, growthStore, tableStore, child) {
        if (!_isActive || !mounted) {
          return const SizedBox.shrink();
        }

        return Observer(
          builder: (context) {
            if (!_isActive || !mounted) {
              return const SizedBox.shrink();
            }

            return TrackerBody(
              isShowInfo: growthStore.isShowInfo,
              setIsShowInfo: (v) => _setInfoSafely(v),
              learnMoreWidgetText: t.trackers.findOutMoreTextHeight,
              onPressLearnMore: () {
                if (_isActive && mounted) {
                  context.pushNamed(AppViews.serviceKnowlegde);
                }
              },
              children: [
                SliverToBoxAdapter(child: 10.h),

                /// Current and Dynamic Container
                SliverToBoxAdapter(
                  child: Observer(
                    builder: (context) {
                      if (!_isActive || !mounted) {
                        return const SizedBox.shrink();
                      }
                      return CurrentAndDymanicContainer(
                        trackerType: EvolutionCategory.growth,
                        current: growthStore.current,
                        dynamic: growthStore.dynamicValue,
                      );
                    },
                  ),
                ),

                /// KG Or gramm Container
                SliverToBoxAdapter(
                  child: trackerType == EvolutionCategory.growth
                      ? Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            top: 16,
                          ),
                          child: Row(
                            children: [
                              SwitchContainer(
                                title1: trackerType.switchContainerTitle1,
                                title2: trackerType.switchContainerTitle2,
                                onSelected: (index) {
                                  if (_isActive && mounted) {
                                    growthStore.switchGrowthUnit(
                                        index == 0 ? GrowthUnit.cm : GrowthUnit.m);
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),

                /// Grafic
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16, top: 0),
                    child: SizedBox(
                      height: 278,
                      child: Observer(
                        builder: (context) {
                          if (!_isActive || !mounted) {
                            return const SizedBox.shrink();
                          }
                          return FlProgressChart(
                            min: growthStore.minValue,
                            max: growthStore.maxValue,
                            chartData: growthStore.chartData,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: EditingButtons(
                      addBtnText: trackerType.addButtonTitle,
                      learnMoreTap: () {
                        if (_isActive && mounted) {
                          context.pushNamed(AppViews.serviceKnowlegde);
                        }
                      },
                      addButtonTap: () {
                        if (_isActive && mounted) {
                          context.pushNamed(AppViews.addGrowthView, extra: {
                            'store': growthStore,
                          });
                        }
                      }),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// Stories
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      t.trackers.stories.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SwitchContainer(
                        title1: t.trackers.news.title,
                        title2: t.trackers.old.title,
                        onSelected: (index) {
                          if (_isActive && mounted) {
                            tableStore.setSortOrder(index);
                            setState(() {});
                          }
                        },
                      ),
                      trackerType.title == EvolutionCategory.head.title
                          ? const SizedBox()
                          : SwitchContainer(
                              title1: trackerType.switchContainerTitle1,
                              title2: trackerType.switchContainerTitle2,
                              onSelected: (index) {
                                if (_isActive && mounted) {
                                  tableStore.setGrowthUnit(
                                      index == 0 ? GrowthUnit.cm : GrowthUnit.m);
                                  setState(() {});
                                }
                              },
                            ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                Observer(
                  builder: (context) {
                    if (!_isActive || !mounted || tableStore.listData.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: _GrowthTableWithShowAll(
                        store: tableStore,
                        isParentActive: () => _isActive && mounted,
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),
              ],
            );
          },
        );
      },
    );
  }
}

class _GrowthTableWithShowAll extends StatefulWidget {
  final GrowthTableStore store;
  final bool Function() isParentActive;
  
  const _GrowthTableWithShowAll({
    required this.store,
    required this.isParentActive,
  });

  @override
  State<_GrowthTableWithShowAll> createState() => _GrowthTableWithShowAllState();
}

class _GrowthTableWithShowAllState extends State<_GrowthTableWithShowAll> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _isActive = true;
  }

  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }

  bool get _isSafeToUpdate => _isActive && mounted && widget.isParentActive();

  @override
  Widget build(BuildContext context) {
    if (!_isSafeToUpdate) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    
    return Column(
      children: [
        Observer(
          builder: (context) {
            if (!_isSafeToUpdate) {
              return const SizedBox.shrink();
            }
            return SkitTableWidget(store: widget.store);
          },
        ),
        Observer(
          builder: (context) {
            if (!_isSafeToUpdate || 
                (!widget.store.canShowAll && !widget.store.canCollapse)) {
              return const SizedBox.shrink();
            }
            
            return Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      if (_isSafeToUpdate) {
                        widget.store.toggleShowAll();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        children: [
                          Text(
                            widget.store.showAll ? 'Свернуть историю' : 'Вся история',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            widget.store.showAll ? Icons.expand_less : Icons.expand_more, 
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ],
    );
  }
}
