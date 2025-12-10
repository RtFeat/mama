import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/core/utils/who_growth_standards.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';
import 'package:mama/src/feature/trackers/widgets/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mobx/mobx.dart';

export 'add_weight.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

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
                  final weightStore = context.read<WeightStore>();
                  final tableStore = context.read<WeightTableStore>();
                  
                  // Очищаем и загружаем данные для нового ребенка
                  weightStore.fetchWeightDetails();
                  
                  // Принудительно загружаем историю для таблицы
                  tableStore.refreshForChild(newChildId);
                  
                  // Дополнительно загружаем историю для WeightStore
                  weightStore.loadPage(newFilters: [
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
      final weightStore = context.read<WeightStore>();
      final tableStore = context.read<WeightTableStore>();
      final userStore = context.read<UserStore>();
      
      // Активируем stores
      weightStore.activate();
      tableStore.activate();
      
      final currentChildId = weightStore.childId;
      
      // Проверяем, нужно ли принудительно обновить хранилища
      if (userStore.shouldRefreshGrowthStores(currentChildId)) {
        weightStore.refreshForChild(currentChildId);
        tableStore.refreshForChild(currentChildId);
      }
      // Убираем дублирующую загрузку - activate() уже загружает данные
      
      // Создаем безопасную асинхронную операцию
      _loadInfoSafely();
    } catch (e) {
      // Игнорируем ошибки
    }
  }

  Future<void> _loadInfoSafely() async {
    if (!_isActive || !mounted) return;
    
    try {
      final weightStore = context.read<WeightStore>();
      await weightStore.getIsShowInfo();
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
      final weightStore = context.read<WeightStore>();
      await weightStore.setIsShowInfo(value);
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
      final weightStore = context.read<WeightStore>();
      final tableStore = context.read<WeightTableStore>();
      weightStore.deactivate();
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

    final trackerType = EvolutionCategory.weight;

    // Используем Consumer вместо context.watch для большего контроля
    return Consumer2<WeightStore, WeightTableStore>(
      builder: (context, weightStore, tableStore, child) {
        if (!_isActive || !mounted) {
          return const SizedBox.shrink();
        }

        return Observer(
          builder: (context) {
            if (!_isActive || !mounted) {
              return const SizedBox.shrink();
            }

            return TrackerBody(
              isShowInfo: weightStore.isShowInfo,
              setIsShowInfo: (v) => _setInfoSafely(v),
              learnMoreWidgetText: t.trackers.findOutMoreTextWeight,
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
                        trackerType: EvolutionCategory.weight,
                        current: weightStore.current,
                        dynamic: weightStore.dynamicValue,
                      );
                    },
                  ),
                ),

                /// KG Or gramm Container
                SliverToBoxAdapter(
                  child: trackerType == EvolutionCategory.weight ||
                          trackerType == EvolutionCategory.growth
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
                                    weightStore.switchWeightUnit(
                                        index == 0 ? WeightUnit.kg : WeightUnit.g);
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
                          // Generate WHO norms for weight
                          final userStore = context.read<UserStore>();
                          final child = userStore.selectedChild;
                          final gender = child?.gender?.name.toLowerCase() ?? 'male';
                          
                          final chartData = weightStore.chartData;
                          
                          // Calculate age range for norm data
                          // We need to get the child's age at first data point
                          List<NormData>? transformedNormData;
                          
                          if (chartData.isNotEmpty) {
                            // Get child's birth date to calculate age
                            final birthDate = child?.birthDate;
                            if (birthDate != null) {
                              // Calculate child's age in days at first data point
                              final firstPointDate = DateTime.fromMillisecondsSinceEpoch(
                                chartData.first.epochDays * Duration.millisecondsPerDay,
                                isUtc: false,
                              );
                              final ageAtFirstPoint = firstPointDate.difference(birthDate).inDays;
                              
                              // Generate norm data starting from child's age at first point
                              // Extend to cover full graph width with padding
                              final minAgeDays = (ageAtFirstPoint - 2).clamp(0, double.infinity).toInt();
                              final maxAgeDays = ageAtFirstPoint + (chartData.last.x - chartData.first.x).toInt() + 60;
                              
                              final rawNormData = WHOGrowthStandards.getWeightNorms(
                                minAgeDays: minAgeDays,
                                maxAgeDays: maxAgeDays,
                                gender: gender,
                              );
                              
                              // Transform norm data to use relative X coordinates (same as chartData)
                              transformedNormData = rawNormData.map((norm) {
                                // Convert absolute age days to relative days from first point
                                final relativeX = norm.x - ageAtFirstPoint;
                                return NormData(
                                  x: relativeX,
                                  median: norm.median,
                                  sd1Lower: norm.sd1Lower,
                                  sd1Upper: norm.sd1Upper,
                                  sd2Lower: norm.sd2Lower,
                                  sd2Upper: norm.sd2Upper,
                                  sd3Lower: norm.sd3Lower,
                                  sd3Upper: norm.sd3Upper,
                                );
                              }).toList();
                            }
                          }
                          
                          return FlProgressChart(
                            min: weightStore.minValue,
                            max: weightStore.maxValue,
                            chartData: weightStore.chartData,
                            normData: transformedNormData,
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
                          context.pushNamed(AppViews.addWeightView, extra: {
                            'store': weightStore,
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
                                  tableStore.setWeightUnit(
                                      index == 0 ? WeightUnit.kg : WeightUnit.g);
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
                      child: _WeightTableWithShowAll(
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

class _WeightTableWithShowAll extends StatefulWidget {
  final WeightTableStore store;
  final bool Function() isParentActive;
  
  const _WeightTableWithShowAll({
    required this.store,
    required this.isParentActive,
  });

  @override
  State<_WeightTableWithShowAll> createState() => _WeightTableWithShowAllState();
}

class _WeightTableWithShowAllState extends State<_WeightTableWithShowAll> {
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