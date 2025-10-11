import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/add_pumping_input.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddPumpingScreen extends StatelessWidget {
  final Object? existing; // can be EntityPumpingHistory
  const AddPumpingScreen({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final existingRec = existing is EntityPumpingHistory ? existing as EntityPumpingHistory : null;
    return Provider(
      create: (context) => AddPumping(),
      dispose: (context, value) => value.dispose(),
      child: Scaffold(
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(t.feeding.pumping,
            style: textTheme.titleMedium
                ?.copyWith(color: const Color(0xFF163C63))),
      ),
      backgroundColor: const Color(0xFFE7F2FE),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            children: [
              const Spacer(),
              const AddPumpingInput(),
              35.h,
              Consumer<AddPumping>(
                builder: (context, addPumping, child) {
                  // Prefill when editing
                  if (existingRec != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final l = existingRec.left ?? 0;
                      final r = existingRec.right ?? 0;
                      if (addPumping.left.value != l) {
                        addPumping.left.value = l;
                      }
                      if (addPumping.right.value != r) {
                        addPumping.right.value = r;
                      }
                      if (addPumping.selectedDateTime == null && existingRec.time != null) {
                        try {
                          final parsed = existingRec.time!.contains('T')
                              ? DateTime.parse(existingRec.time!)
                              : DateFormat('yyyy-MM-dd HH:mm:ss').parse(existingRec.time!);
                          addPumping.setSelectedDateTime(parsed.toLocal());
                        } catch (_) {}
                      }
                    });
                  }
                  return DateTimeSelectorWidget(
                    onChanged: (value) {
                      addPumping.setSelectedDateTime(value);
                    },
                  );
                },
              ),
              30.h,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 48,
                      width: double.infinity,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      type: CustomButtonType.outline,
                      // icon: IconModel(
                      //     color: AppColors.primaryColor,
                      //     iconPath: Assets.icons.icPencilFilled),

                      icon: AppIcons.pencil,
                      iconColor: AppColors.primaryColor,
                      title: t.feeding.note,
                      onTap: () {
                        context.pushNamed(AppViews.addNote);
                      },
                    ),
                  ),
                  10.w,
                  Expanded(
                    child: CustomButton(
                      backgroundColor: AppColors.redLighterBackgroundColor,
                      height: 48,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      type: CustomButtonType.filled,
                      // icon: IconModel(iconPath: Assets.icons.icClose),
                      icon: AppIcons.xmark,
                      iconColor: AppColors.redColor,
                      title: t.feeding.cancel,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              10.h,
              Consumer<AddPumping>(
                builder: (context, addPumping, child) {
                  return StreamBuilder<Object?>(
                    stream: addPumping.formGroup.valueChanges,
                    initialData: addPumping.formGroup.value,
                    builder: (context, snapshot) {
                      final leftValue = _extractNumericValue(addPumping.left.value);
                      final rightValue = _extractNumericValue(addPumping.right.value);
                      final totalValue = leftValue + rightValue;
                      final bool enabled = totalValue > 0;
                      final isEditing = existingRec != null;
                      return CustomButton(
                        backgroundColor: enabled ? AppColors.greenLighterBackgroundColor : const Color(0xFFCED1D9),
                        height: 48,
                        width: double.infinity,
                        title: isEditing ? t.trackers.save : t.feeding.confirm,
                        textStyle: textTheme.bodyMedium
                            ?.copyWith(color: enabled ? AppColors.greenTextColor : Colors.white),
                        onTap: !enabled
                            ? null
                            : () async {
                                final userStore = context.read<UserStore>();
                                final restClient = context.read<Dependencies>().restClient;
                                final noteStore = context.read<AddNoteStore>();

                                final selected = addPumping.selectedDateTime ?? DateTime.now();
                                final String sendingTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(selected.toUtc());
                                final dto = FeedInsertPumpingDto(
                                  childId: userStore.selectedChild!.id,
                                  timeToEnd: sendingTime,
                                  left: leftValue > 0 ? leftValue : null,
                                  right: rightValue > 0 ? rightValue : null,
                                  all: totalValue,
                                  notes: noteStore.content?.isNotEmpty == true ? noteStore.content : '',
                                );

                                try {
                                  if (isEditing) {
                                    final deps = context.read<Dependencies>();
                                    String? id = existingRec?.id;
                                    if (!_isUuid(id)) {
                                      // Try resolve real id from server by matching fields
                                      final childId = userStore.selectedChild?.id;
                                      id = await _resolvePumpingId(deps, childId, existingRec);
                                    }

                                    if (id != null && id.isNotEmpty) {
                                      // Update existing via stats endpoint
                                      await deps.apiClient.patch('feed/pumping/stats', body: {
                                        'id': id,
                                        'child_id': userStore.selectedChild!.id,
                                        'time_to_end': sendingTime,
                                        if (leftValue > 0) 'left': leftValue,
                                        if (rightValue > 0) 'right': rightValue,
                                        'all': totalValue,
                                      });
                                      // notes могут не сохраняться через /stats; патчим отдельно, если переданы
                                      if (noteStore.content != null) {
                                        final notesStr = noteStore.content!.trim();
                                        // Патчим даже пустые (для очистки), если пользователь удалил текст
                                        await deps.apiClient.patch('feed/pumping/notes', body: {
                                          'id': id,
                                          'notes': notesStr,
                                        });
                                      }
                                    } else {
                                      // Fallback to create if id cannot be resolved
                                      await restClient.feed.postFeedPumping(dto: dto);
                                    }
                                  } else {
                                    await restClient.feed.postFeedPumping(dto: dto);
                                  }
                                  if (context.mounted) {
                                    context.pop(true); // indicate success to parent
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Ошибка при сохранении: $e')),
                                    );
                                  }
                                }
                              },
                      );
                    },
                  );
                },
              ),
              20.h,
            ],
          ),
        ),
        ),
      ),
    );
  }

  int _extractNumericValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Убираем все нецифровые символы (включая пробелы, неразрывные пробелы и суффиксы)
      final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digitsOnly.isEmpty) return 0;
      return int.tryParse(digitsOnly) ?? 0;
    }
    return 0;
  }

  bool _isUuid(String? id) {
    if (id == null) return false;
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12} ?$', caseSensitive: false);
    return uuidRegex.hasMatch(id);
  }

  Future<String?> _resolvePumpingId(Dependencies deps, String? childId, EntityPumpingHistory? rec) async {
    if (childId == null || rec == null) return null;
    try {
      final response = await deps.restClient.feed.getFeedPumpingGet(childId: childId);
      if (response.list != null) {
        for (final item in response.list!) {
          if (item.timeToEnd == rec.time && item.leftFeeding == rec.left && item.rightFeeding == rec.right) {
            return item.id;
          }
        }
      }
    } catch (_) {}
    return null;
  }
}
