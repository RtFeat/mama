import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/trackers/widgets/date_time_selector.dart';
import 'package:mama/src/core/widgets/custom_button.dart';
import 'package:skit/skit.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum BottleType { breast, formula }

class AddBottleScreen extends StatefulWidget {
  final Object? existing; // can be EntityFood
  const AddBottleScreen({super.key, this.existing});

  @override
  State<AddBottleScreen> createState() => _AddBottleScreenState();
}

class _AddBottleScreenState extends State<AddBottleScreen> {
  EntityFood? get existingRec => widget.existing is EntityFood ? widget.existing as EntityFood : null;
  BottleType _type = BottleType.breast;
  int _ml = 100;
  DateTime? _selectedDateTime;
  String? _noteText;
  
  // Состояние для последовательного ввода
  bool _breastAdded = false;
  bool _formulaAdded = false;
  int? _breastMl;
  int? _formulaMl;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(
          t.feeding.bottle,
          style: textTheme.titleMedium?.copyWith(color: const Color(0xFF163C63)),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            // Рулер объема в мл (как на Add growth/weight)
            UniversalRuler(
              config: RulerConfig(
                height: 200,
                mainDashHeight: 140,
                longDashHeight: 120,
                width: 16,
                shortDashHeight: 50,
              ),
              min: 0,
              max: 500,
              step: 10,
              value: _ml.toDouble(),
              labelStep: 10,
              unit: 'мл',
              onChanged: (v) {
                setState(() {
                  _ml = v.toInt();
                });
              },
            ),
            // Карточка с типом и вводом количества
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _typeVerticalToggle(),
                        16.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$_ml',
                                        style: textTheme.displaySmall?.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 64,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'мл',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              8.h,
                              Container(height: 2, color: AppColors.primaryColor.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    12.h,
                    8.h,
                    DateTimeSelectorWidget(
                      onChanged: (v) {
                        setState(() => _selectedDateTime = v);
                      },
                    ),
                    12.h,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            type: CustomButtonType.outline,
                            icon: AppIcons.pencil,
                            iconColor: AppColors.primaryColor,
                            title: t.trackers.note.title,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                            onTap: () {
                              context.pushNamed(AppViews.addNote, extra: {
                                'initialValue': _noteText,
                                'onSaved': (String value) {
                                  setState(() {
                                    _noteText = value;
                                  });
                                },
                              });
                            },
                          ),
                        ),
                        10.w,
                    Expanded(
                          child: CustomButton(
                            backgroundColor: AppColors.purpleLighterBackgroundColor,
                            title: t.trackers.add.title,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                        onTap: () async {
                          // Сохраняем одну запись по текущему выбранному типу без автопереключения
                          final deps = context.read<Dependencies>();
                          final user = context.read<UserStore>();
                          final childId = user.selectedChild?.id;
                          if (childId == null) return;

                          final now = DateTime.now();
                          final when = _selectedDateTime ?? now;
                          final timeToEnd = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                              .format(when.toUtc());

                          final bool isBreast = _type == BottleType.breast;
                          final int chestMl = isBreast ? _ml : 0;
                          final int mixtureMl = isBreast ? 0 : _ml;

                          try {
                            if (existingRec != null && (existingRec!.id?.isNotEmpty == true)) {
                              // Edit flow: PATCH /feed/food/stats then optionally /feed/food/notes
                              await deps.apiClient.patch('feed/food/stats', body: {
                                'id': existingRec!.id,
                                'child_id': childId,
                                'time_to_end': timeToEnd,
                                'chest': chestMl,
                                'mixture': mixtureMl,
                              });
                              if (_noteText != null) {
                                await deps.apiClient.patch('feed/food/notes', body: {
                                  'id': existingRec!.id,
                                  'notes': _noteText,
                                });
                              }
                            } else {
                              final dto = FeedInsertFoodDto(
                                childId: childId,
                                timeToEnd: timeToEnd,
                                chest: chestMl,
                                mixture: mixtureMl,
                                notes: _noteText,
                              );
                              await deps.restClient.feed.postFeedFood(dto: dto);
                            }
                            if (mounted) {
                              // Очищаем заметку после успешного сохранения
                              setState(() {
                                _noteText = null;
                              });
                              await Future.delayed(const Duration(milliseconds: 200));
                              context.pop(true);
                            }
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка сохранения: $e')),
                            );
                          }
                        },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _typeVerticalToggle() {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.purpleLighterBackgroundColor,
      ),
      child: Column(
        children: [
          _typeToggleItem('Грудь', _type == BottleType.breast, () {
            setState(() => _type = BottleType.breast);
          }),
          _typeToggleItem('Смесь', _type == BottleType.formula, () {
            setState(() => _type = BottleType.formula);
          }),
        ],
      ),
    );
  }

  Widget _typeToggleItem(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 30,
        width: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppColors.whiteColor : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? AppColors.primaryColor : AppColors.greyBrighterColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
