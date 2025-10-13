import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/switch_container.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_widget.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_week_table.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/feature/trackers/widgets/date_range_selector.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_history_table.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry_table_store.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';
import 'package:mobx/mobx.dart';

class CryScreen extends StatefulWidget {
  final bool isActiveTab;
  const CryScreen({super.key, this.isActiveTab = true});

  @override
  State<CryScreen> createState() => _CryScreenState();
}

class _CryScreenState extends State<CryScreen> {
  // Флаг для отслеживания активности виджета
  bool _isActive = false;
  
  // Список для управления MobX reactions
  final List<ReactionDisposer> _disposers = [];
  
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  late final CryTableStore _cryTableStore;
  late final TemperatureInfoStore _infoStore;

  @override
  void initState() {
    super.initState();
    _isActive = true;
    
    final now = DateTime.now();
    final int weekday = now.weekday;
    startOfWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));

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
                  // Очищаем и загружаем данные для нового ребенка
                  _cryTableStore.refreshForChild(newChildId);
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
      final deps = context.read<Dependencies>();
      _cryTableStore = CryTableStore(
        apiClient: deps.apiClient,
        restClient: deps.restClient,
        faker: deps.faker,
        userStore: context.read<UserStore>(),
      );
      
      final prefs = deps.sharedPreferences;
      _infoStore = TemperatureInfoStore(
        onLoad: () async => prefs.getBool('cry_info') ?? true,
        onSet: (v) async => prefs.setBool('cry_info', v),
      );
      
      // Активируем store
      _cryTableStore.activate();
      
      final currentChildId = _cryTableStore.childId;
      print('CryScreen _initializeStores: Current childId = $currentChildId');
      
      if (currentChildId.isNotEmpty) {
        // Загружаем данные плача
        _cryTableStore.loadPage(
          newFilters: [
            SkitFilter(
              field: 'child_id',
              operator: FilterOperator.equals,
              value: currentChildId,
            ),
          ],
        ).then((_) {
          print('CryScreen: Table loaded with ${_cryTableStore.listData.length} items');
        });
      }
      
      // Создаем безопасную асинхронную операцию
      _loadInfoSafely();
    } catch (e) {
      print('CryScreen _initializeStores error: $e');
    }
  }

  Future<void> _loadInfoSafely() async {
    if (!_isActive || !mounted) return;
    
    try {
      await _infoStore.getIsShowInfo();
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
      await _infoStore.setIsShowInfo(value);
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
    
    // Деактивируем store если он был инициализирован
    try {
      _cryTableStore.deactivate();
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

    return Provider.value(
      value: _cryTableStore,
      child: TrackerBody(
          isShowInfo: _infoStore.isShowInfo,
          setIsShowInfo: (v) => _setInfoSafely(v),
          learnMoreWidgetText: t.trackers.findOutMoreTextCry,
          onPressLearnMore: () {
            if (_isActive && mounted) {
              context.pushNamed(AppViews.serviceKnowlegde);
            }
          },
          children: [
            const SliverToBoxAdapter(child: CryWidget()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  DateRangeSelectorWidget(
                    startDate: startOfWeek,
                    endDate: endOfWeek,
                    onLeftTap: () {
                      if (_isActive && mounted) {
                        setState(() {
                          startOfWeek = startOfWeek.subtract(const Duration(days: 7));
                          endOfWeek = startOfWeek.add(const Duration(days: 6));
                        });
                        final userStore = context.read<UserStore>();
                        final childId = userStore.selectedChild?.id ?? '';
                        _cryTableStore.loadPage(newFilters: [
                          SkitFilter(
                              field: 'child_id',
                              operator: FilterOperator.equals,
                              value: childId),
                        ]);
                      }
                    },
                    onRightTap: () {
                      if (_isActive && mounted) {
                        setState(() {
                          startOfWeek = startOfWeek.add(const Duration(days: 7));
                          endOfWeek = startOfWeek.add(const Duration(days: 6));
                        });
                        final userStore = context.read<UserStore>();
                        final childId = userStore.selectedChild?.id ?? '';
                        _cryTableStore.loadPage(newFilters: [
                          SkitFilter(
                              field: 'child_id',
                              operator: FilterOperator.equals,
                              value: childId),
                        ]);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  CryWeekTableWidget(startOfWeek: startOfWeek),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: CryHistoryTableWidget()),
          ]),
    );
  }
}
