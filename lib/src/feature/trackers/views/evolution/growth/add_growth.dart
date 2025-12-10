import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddGrowthView extends StatelessWidget {
  // final GrowthViewStore? store;
  const AddGrowthView({
    super.key,
    // this.store
  });

  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _prefilled = false;
  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();

    final AddGrowthViewStore addGrowthViewStore =
        context.watch<AddGrowthViewStore>();

    final GrowthStore store = context.watch<GrowthStore>();
    final GrowthTableStore tableStore = context.watch<GrowthTableStore>();

    // Detect edit mode from router extra
    final Map? extra = GoRouterState.of(context).extra as Map?;
    final EntityHistoryHeight? existing =
        extra != null ? extra['entity'] as EntityHistoryHeight? : null;

    // Prefill once in edit mode
    if (existing != null && !_prefilled) {
      final raw = (existing.height ?? '').replaceAll(',', '.');
      final parsed = double.tryParse(raw) ?? 0;
      addGrowthViewStore.updateGrowth(parsed);
      _prefilled = true;
    }

    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: existing == null ? t.trackers.growth.add : t.trackers.edit,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.trackerColor,
              fontSize: 17,
              letterSpacing: -0.5,
            ),
      ),
      body: ListView(
        children: [
          UniversalRuler(
            config: RulerConfig(
              height: 200,
              mainDashHeight: 163,
              longDashHeight: 142,
              width: 8,
              shortDashHeight: 54,
            ),
            min: 10,
            max: 150,
            step: 1,
            initial: addGrowthViewStore.growth.toDouble(),
            value: addGrowthViewStore.growth.toDouble(),
            labelStep: 10,
            unit: t.trackers.cm.title,
            onChanged: (v) {
              addGrowthViewStore.updateGrowth(v);
              setState(() {});
            },
          ),
          8.h,
          Observer(builder: (context) {
            return CustomBlog(
              measure: UnitMeasures.height,
              value: addGrowthViewStore.growthValue,
              onChangedValue: (v) {
                addGrowthViewStore.updateGrowthRaw(v);
                setState(() {});
              },
              onChangedTime: addGrowthViewStore.updateDateTime,
              onPressedElevated: addGrowthViewStore.isFormValid
                  ? () async {
                      if (existing == null) {
                        await addGrowthViewStore
                            .add(userStore.selectedChild!.id!, noteStore.content);
                      } else {
                        await addGrowthViewStore.edit(
                          childId: userStore.selectedChild!.id!,
                          id: existing.id ?? '',
                          notes: noteStore.content,
                        );
                      }
                      if (context.mounted) {
                        // Очищаем заметку после успешного сохранения
                        noteStore.setContent(null);
                        context.pop();
                        if (context.mounted) {
                          await store.fetchGrowthDetails();
                          await tableStore.refresh();
                        }
                      }
                    }
                  : null,
            );
          }),
          8.h,
        ],
      ),
    );
  }
}
