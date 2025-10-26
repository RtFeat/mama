import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep_table_store.dart';
import 'package:mama/src/feature/trackers/widgets/switch_container.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/feature/trackers/widgets/date_range_selector.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/week_table.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/sleep_history_table.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';
import 'package:mobx/mobx.dart';

class SleepScreen extends StatefulWidget {
  final bool isActiveTab;
  const SleepScreen({super.key, this.isActiveTab = true});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  // Флаг для отслеживания активности виджета
  bool _isActive = false;
  
  // Список для управления MobX reactions
  final List<ReactionDisposer> _disposers = [];
  
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  late final TemperatureInfoStore _infoStore;

  @override
  void initState() {
    super.initState();
    _isActive = true;
    
    final now = DateTime.now();
    final int weekday = now.weekday; // 1..7 (Mon..Sun)
    startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('sleep_info') ?? true,
      onSet: (v) async => prefs.setBool('sleep_info', v),
    );
    
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
                  final sleepTableStore = context.read<SleepTableStore>();
                  
                  // Очищаем и загружаем данные для нового ребенка
                  sleepTableStore.refreshForChild(newChildId);
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
      final sleepTableStore = context.read<SleepTableStore>();
      
      // Активируем store
      sleepTableStore.activate();
      
      final currentChildId = sleepTableStore.childId;
      
      if (currentChildId.isNotEmpty) {
        // Загружаем данные таблицы
        sleepTableStore.loadPage(
          newFilters: [
            SkitFilter(
              field: 'child_id',
              operator: FilterOperator.equals,
              value: currentChildId,
            ),
          ],
        ).then((_) {
          // Table loaded
        });
      }
      
      // Загружаем информацию
      _infoStore.getIsShowInfo().then((_) {
        if (_isActive && mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      // Error initializing stores
    }
  }

  @override
  void dispose() {
    _isActive = false;
    
    // Деактивируем store если он был инициализирован
    try {
      final sleepTableStore = context.read<SleepTableStore>();
      sleepTableStore.deactivate();
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

    return TrackerBody(
        isShowInfo: _infoStore.isShowInfo,
        setIsShowInfo: (v) {
          if (_isActive && mounted) {
            _infoStore.setIsShowInfo(v).then((_) {
              if (_isActive && mounted) {
                setState(() {});
              }
            });
          }
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextSleep,
        onPressLearnMore: () {
          if (_isActive && mounted) {
            context.pushNamed(AppViews.serviceKnowlegde);
          }
        },
        children: [
          const SliverToBoxAdapter(child: SleepWidget()),
          SliverToBoxAdapter(
            child: Builder(builder: (context) {
              final sleepStore = context.watch<SleepStore>();
              final hideWeek = sleepStore.showEditMenu; // прячем неделю, когда открыт таймер/редактор
              if (hideWeek) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  const SizedBox(height: 8),
                  DateRangeSelectorWidget(
                  startDate: startOfWeek,
                  endDate: endOfWeek,
                  onLeftTap: () async {
                    if (_isActive && mounted) {
                      setState(() {
                        startOfWeek =
                            startOfWeek.subtract(const Duration(days: 7));
                        endOfWeek = startOfWeek.add(const Duration(days: 6));
                      });
                      // Обновляем данные при смене недели
                      final sleepTableStore = context.read<SleepTableStore>();
                      final userStore = context.read<UserStore>();
                      final childId = userStore.selectedChild?.id ?? '';
                      
                      sleepTableStore.loadPage(newFilters: [
                        SkitFilter(
                            field: 'child_id',
                            operator: FilterOperator.equals,
                            value: childId),
                      ]);
                    }
                  },
                  onRightTap: () async {
                    if (_isActive && mounted) {
                      setState(() {
                        startOfWeek = startOfWeek.add(const Duration(days: 7));
                        endOfWeek = startOfWeek.add(const Duration(days: 6));
                      });
                      // Обновляем данные при смене недели
                      final sleepTableStore = context.read<SleepTableStore>();
                      final userStore = context.read<UserStore>();
                      final childId = userStore.selectedChild?.id ?? '';
                      
                      sleepTableStore.loadPage(newFilters: [
                        SkitFilter(
                            field: 'child_id',
                            operator: FilterOperator.equals,
                            value: childId),
                      ]);
                    }
                  },
                ),
                const SizedBox(height: 8),
                WeekTableWidget(startOfWeek: startOfWeek),
                const SizedBox(height: 8),
              ],
              );
            }),
          ),
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
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          const SliverToBoxAdapter(
            child: SleepHistoryTableWidget(),
          ),
        ]);
  }
}

