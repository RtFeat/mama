import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddCircleView extends StatelessWidget {
  const AddCircleView({
    super.key,
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

    final AddCircleViewStore addCircleViewStore =
        context.watch<AddCircleViewStore>();

    final CircleStore store = context.watch<CircleStore>();
    final CircleTableStore tableStore = context.watch<CircleTableStore>();

    // Detect edit mode from router extra
    final Map? extra = GoRouterState.of(context).extra as Map?;
    final EntityHistoryCircle? existing =
        extra != null ? extra['entity'] as EntityHistoryCircle? : null;

    // Prefill values in edit mode once
    if (existing != null && !_prefilled) {
      final raw = (existing.circle ?? '').replaceAll(',', '.');
      final parsed = double.tryParse(raw) ?? 0;
      addCircleViewStore.updateCircle(parsed);
      _prefilled = true;
    }

    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: existing == null ? t.trackers.head.add : t.trackers.edit,
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
            max: 50,
            step: 1,
            initial: addCircleViewStore.circle.toDouble(),
            value: addCircleViewStore.circle.toDouble(),
            labelStep: 10,
            unit: t.trackers.cm.title,
            onChanged: (v) {
              addCircleViewStore.updateCircle(v);
              setState(() {});
            },
          ),
          8.h,
          Observer(builder: (context) {
            return CustomBlog(
              measure: UnitMeasures.head,
              value: addCircleViewStore.circleValue,
              onChangedValue: (v) {
                addCircleViewStore.updateCircleRaw(v);
                setState(() {});
              },
              onChangedTime: addCircleViewStore.updateDateTime,
              onPressedElevated: addCircleViewStore.isFormValid
                  ? () async {
                      if (existing == null) {
                        await addCircleViewStore
                            .add(userStore.selectedChild!.id!, noteStore.content);
                      } else {
                        await addCircleViewStore.edit(
                          childId: userStore.selectedChild!.id!,
                          id: existing.id ?? '',
                          notes: noteStore.content,
                        );
                      }
                      if (context.mounted) {
                        context.pop();
                        if (context.mounted) {
                          await store.fetchCircleDetails();
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
