import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:mobx/mobx.dart';

class TablePage extends StatelessWidget {
  const TablePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TableEvolutionHistory(
          store: context.watch(),
        ),
      ),
    );
  }
}

class TableEvolutionHistory extends StatefulWidget {
  final EvolutionTableStore store;

  const TableEvolutionHistory({
    super.key,
    required this.store,
  });

  @override
  State<TableEvolutionHistory> createState() => _TableEvolutionHistoryState();
}

class _TableEvolutionHistoryState extends State<TableEvolutionHistory> {
  // Флаг для отслеживания активности виджета
  bool _isActive = false;
  
  // Список для управления MobX reactions
  final List<ReactionDisposer> _disposers = [];
  
  List<bool> isSelectedWeight = [true, false];
  List<bool> isSelectedHeight = [true, false];

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
                  // Очищаем и загружаем данные для нового ребенка
                  widget.store.refreshForChild(newChildId);
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
      // Активируем store
      widget.store.activate();
      
      final currentChildId = widget.store.childId;
      print('TableEvolutionHistory _initializeStores: Current childId = $currentChildId');
      
      if (currentChildId.isNotEmpty) {
        // Загружаем данные таблицы
        widget.store.loadPage(
          newFilters: [
            SkitFilter(
              field: 'child_id',
              operator: FilterOperator.equals,
              value: currentChildId,
            ),
          ],
        ).then((_) {
          print('TableEvolutionHistory: Table loaded with ${widget.store.listData.length} items');
        });
      }
    } catch (e) {
      print('TableEvolutionHistory _initializeStores error: $e');
    }
  }

  @override
  void dispose() {
    _isActive = false;
    
    // Деактивируем store если он был инициализирован
    try {
      widget.store.deactivate();
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

    return Observer(builder: (context) {
      if (!_isActive || !mounted) return const SizedBox.shrink();
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    CustomToggleButton(
                        alignment: Alignment.topLeft,
                        items: [t.feeding.newS, t.feeding.old],
                        onTap: (index) {
                          if (_isActive && mounted) {
                            widget.store.setSortOrder(index);
                            setState(() {});
                          }
                        },
                        btnWidth: 64,
                        btnHeight: 26),
                    Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          CustomButton(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            icon: AppIcons.arrowDownToLineCompact,
                            title: t.trackers.pdf.title,
                            height: 26,
                            width: 70,
                            onTap: () {
                              if (_isActive && mounted) {
                                PdfService.generateAndViewGrowthPdf(
                                  context: context,
                                  typeOfPdf: 'growth',
                                  title: t.trackers.report,
                                  onStart: () => _showSnack(context, 'Generating PDF...', bg: AppColors.primaryColor),
                                  onSuccess: () => _showSnack(context, 'PDF generated successfully!', bg: Colors.green, seconds: 3),
                                  onError: (m) => _showSnack(context, m),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
                15.h,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Text(
                      t.trackers.evolution.attention,
                      style: AppTextStyles.f10w700
                          .copyWith(color: AppColors.greyBrighterColor),
                    ),
                    10.h,

                    // Индикаторы
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildIndicator(
                          label: t.trackers.evolution.norm,
                          color: AppColors.greenLighterBackgroundColor,
                          textColor: AppColors.greenTextColor,
                        ),
                        10.w,
                        _buildIndicator(
                          label: t.trackers.evolution.anormal,
                          color: AppColors.yellowBackgroundColor,
                          textColor: AppColors.orangeTextColor,
                        ),
                      ],
                    ),
                    12.h,
                  ],
                ),
                10.w,
                VericalToogleCustom(
                  width: 50,
                  isSelected: isSelectedWeight,
                  measure: UnitMeasures.weight,
                  onChange: (int index) {
                    if (_isActive && mounted) {
                      widget.store.setWeightUnit(
                          index == 0 ? WeightUnit.kg : WeightUnit.g);
                      setState(() {});
                    }
                  },
                ),
                10.w,
                VericalToogleCustom(
                  width: 50,
                  isSelected: isSelectedHeight,
                  measure: UnitMeasures.height,
                  onChange: (int index) {
                    if (_isActive && mounted) {
                      widget.store.setCircleUnit(
                        index == 0 ? CircleUnit.cm : CircleUnit.m,
                      );
                      setState(() {});
                    }
                  },
                ),
                40.w,
              ],
            ),
          ),
          if (widget.store.listData.isNotEmpty)
            SliverToBoxAdapter(
              child: SkitTableWidget(
                store: widget.store,
              ),
            ),
          // TODO виджет для добавления строк
        ],
      );
    });
  }

  Widget _buildIndicator({
    required String label,
    required Color? color,
    required Color textColor,
  }) {
    return Container(
      width: 85,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.f10w700.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showSnack(BuildContext ctx, String message, {Color? bg, int seconds = 2}) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        ScaffoldMessenger.of(ctx)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: bg,
            duration: Duration(seconds: seconds),
          ));
      } catch (_) {}
    });
  }
}
