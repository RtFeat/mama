import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddWeightView extends StatelessWidget {
  const AddWeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return
        //  Provider(
        //     create: (context) => AddWeightViewStore(
        //         store: store, restClient: context.read<Dependencies>().restClient),
        //     builder: (context, child) =>
        _Body(
            // )
            );
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

    final AddWeightViewStore addWeightViewStore =
        context.watch<AddWeightViewStore>();

    final WeightStore store = context.watch<WeightStore>();
    final WeightTableStore tableStore = context.watch<WeightTableStore>();

    // Detect edit mode from router extra
    final Map? extra = GoRouterState.of(context).extra as Map?;
    final EntityHistoryWeight? existing = extra != null ? extra['entity'] as EntityHistoryWeight? : null;

    // Prefill store once when opening in edit mode
    if (existing != null && !_prefilled) {
      final raw = (existing.weight ?? '').replaceAll(',', '.');
      final parsed = double.tryParse(raw) ?? 0;
      final kg = parsed.truncate();
      final grams = ((parsed - kg) * 1000).round().clamp(0, 999);
      addWeightViewStore.updateKilograms(kg);
      addWeightViewStore.updateGrams(grams);
      _prefilled = true;
    }

    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: existing == null ? t.trackers.weight.add : t.trackers.edit,
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
              height: 95.5,
              mainDashHeight: 59.5,
              longDashHeight: 39,
              width: 8,
              shortDashHeight: 20,
            ),
            min: 0,
            max: 10,
            step: 0.1,
            initial: addWeightViewStore.kilograms.toDouble(),
            value: addWeightViewStore.kilograms.toDouble(),
            labelStep: 10,
            unit: t.trackers.kg.title,
            onChanged: (v) {
              addWeightViewStore.updateKilograms(v.toInt());
              setState(() {});
            },
          ),
          8.h,
          UniversalRuler(
            config: RulerConfig(
              height: 95.5,
              mainDashHeight: 59.5,
              longDashHeight: 39,
              width: 8,
              shortDashHeight: 20,
            ),
            min: 0,
            max: 1000,
            step: 10,
            initial: addWeightViewStore.grams.toDouble(),
            value: addWeightViewStore.grams.toDouble(),
            labelStep: 10,
            unit: t.trackers.g.title,
            onChanged: (v) {
              addWeightViewStore.updateGrams(v.toInt());
              setState(() {});
            },
          ),
          8.h,
          Observer(builder: (context) {
            return CustomBlog(
              measure: UnitMeasures.weight,
              value: addWeightViewStore.inputValue,
              onChangedValue: (v) {
                addWeightViewStore.updateWeightRaw(v);
                logger.info(v);
                setState(() {});
              },
              onChangedTime: addWeightViewStore.updateDateTime,
              onPressedElevated: addWeightViewStore.isFormValid
                  ? () async {
                      if (existing == null) {
                        addWeightViewStore
                            .add(userStore.selectedChild!.id!, noteStore.content)
                            .then((v) async {
                          if (context.mounted) {
                            context.pop();
                            if (context.mounted) {
                              await store.fetchWeightDetails();
                              await tableStore.refresh();
                            }
                          }
                        });
                      } else {
                        // Edit flow: PATCH /growth/weight/stats
                        await addWeightViewStore.edit(
                          childId: userStore.selectedChild!.id!,
                          id: existing.id ?? '',
                          notes: noteStore.content,
                        );
                        if (context.mounted) {
                          context.pop();
                          if (context.mounted) {
                            await store.fetchWeightDetails();
                            await tableStore.refresh();
                          }
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