import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';

class AddSleepingView extends StatefulWidget {
  const AddSleepingView({super.key});

  @override
  State<AddSleepingView> createState() => _AddSleepingViewState();
}

class _AddSleepingViewState extends State<AddSleepingView> {
  late FormGroup formGroup;

  @override
  void initState() {
    formGroup = FormGroup({
      'sleepStart': FormControl(),
      'sleepEnd': FormControl(),
    });
    // Инициализируем timerEndTime для ручного режима
    final addSleeping = context.read<SleepStore>();
    if (addSleeping.timerEndTime == null) {
      addSleeping.timerEndTime = DateTime.now();
    }
    super.initState();
  }

  @override
  void dispose() {
    formGroup.dispose();
    
    // Сбрасываем состояние CryStore при выходе без сохранения
    try {
      final cryStore = context.read<CryStore>();
      cryStore.resetWithoutSaving();
    } catch (_) {
      // CryStore может быть недоступен на этом роуте
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SleepStore addSleeping = context.watch<SleepStore>();
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();

    return ReactiveForm(
      formGroup: formGroup,
      child: BodyAddManuallySleepCryFeeding(
        stopIfStarted: () {
          addSleeping.cancelSleeping();
        },
        needIfEditNotCompleteMessage: true,
        timerManualStart: addSleeping.timerStartTime,
        timerManualEnd: addSleeping.timerEndTime,
        formControlNameEnd: 'sleepEnd',
        formControlNameStart: 'sleepStart',
        onStartTimeChanged: (v) {
          if (v != null && v.timeToDateTime != null) {
            final now = DateTime.now();
            addSleeping.updateStartTime(v.timeToDateTime!
                .copyWith(year: now.year, month: now.month, day: now.day));
          }
        },
        onEndTimeChanged: (v) {
          if (v != null && v.timeToDateTime != null) {
            final now = DateTime.now();
            addSleeping.updateEndTime(v.timeToDateTime!
                .copyWith(year: now.year, month: now.month, day: now.day));
          }
        },
        isTimerStart: addSleeping.timerSleepStart,
        onTapNotes: () {
          context.pushNamed(AppViews.addNote);
        },
        onTapConfirm: () async {
          await addSleeping.add(userStore.selectedChild!.id!, noteStore.content);
          // Обновляем Stories для сна
          final sleepTableStore = context.read<SleepTableStore>();
          sleepTableStore.resetPagination();
          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);
          final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          sleepTableStore.loadPage(newFilters: [
            SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: userStore.selectedChild!.id),
          ]);
          Future.delayed(const Duration(milliseconds: 600), () {
            final now = DateTime.now();
            final startOfMonth = DateTime(now.year, now.month, 1);
            final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
            sleepTableStore.resetPagination();
            sleepTableStore.loadPage(newFilters: [
              SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: userStore.selectedChild!.id),
            ]);
          });
          // Сбросить таймерные значения (Start/End/Total) после подтверждения
          addSleeping.resetWithoutSaving();
          
          // Также сбрасываем состояние CryStore, чтобы избежать конфликта с таймером Cry
          try {
            final cryStore = context.read<CryStore>();
            cryStore.resetWithoutSaving();
          } catch (_) {
            // CryStore может быть недоступен на этом роуте
          }
          
          if (context.mounted) context.pop();
        },
        titleIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.title,
        textIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.text,
        bodyWidget: BodyCommentSleep(
          titleAddNewManual: t.trackers.addNewManualSleep.title,
          textAddNewManual: t.trackers.addNewManualSleep.text,
        ),
      ),
    );
  }
}

class BodyCommentSleep extends StatelessWidget {
  final String titleAddNewManual;
  final String textAddNewManual;
  const BodyCommentSleep(
      {super.key,
      required this.titleAddNewManual,
      required this.textAddNewManual});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyColor, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              titleAddNewManual,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20, color: AppColors.greyBrighterColor),
            ),
            16.h,
            Row(
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    textAddNewManual,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14, color: AppColors.greyBrighterColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
