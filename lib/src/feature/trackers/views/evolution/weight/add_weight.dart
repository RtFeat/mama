import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddWeightView extends StatelessWidget {
  // final WeightViewStore? store;
  const AddWeightView({
    super.key,
    // this.store
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AddWeightViewStore(
            // store: store,
            restClient: context.read<Dependencies>().restClient),
        builder: (context, child) => _Body(
              // store: store,
              addWeightViewStore: context.watch(),
            ));
  }
}

class _Body extends StatefulWidget {
  const _Body({
    // this.store,
    this.addWeightViewStore,
  });

  // final WeightViewStore? store;
  final AddWeightViewStore? addWeightViewStore;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();

    return Scaffold(
      backgroundColor: AppColors.blueLighter1,
      appBar: CustomAppBar(
        title: t.trackers.weight.add,
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
            value: widget.addWeightViewStore?.kilograms.toDouble() ?? 0.0,
            labelStep: 10,
            unit: t.trackers.kg.title,
            onChanged: (v) {
              widget.addWeightViewStore?.updateKilograms(v.toInt());
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
            initial: widget.addWeightViewStore?.grams.toDouble() ?? 0,
            value: widget.addWeightViewStore?.grams.toDouble() ?? 0.0,
            labelStep: 10,
            unit: t.trackers.g.title,
            onChanged: (v) {
              widget.addWeightViewStore?.updateGrams(v.toInt());
              setState(() {});
            },
          ),
          8.h,
          Observer(builder: (context) {
            return CustomBlog(
              measure: UnitMeasures.weight,
              value: widget.addWeightViewStore?.inputValue ?? '',
              onChangedValue: (v) {
                widget.addWeightViewStore?.updateWeightRaw(v);
                logger.info(v);
                setState(() {});
              },
              onChangedTime: widget.addWeightViewStore?.updateDateTime,
              onPressedElevated: () {
                widget.addWeightViewStore
                    ?.add(userStore.selectedChild!.id!, noteStore.content)
                    .then((v) {
                  if (context.mounted) {
                    context.pop();
                  }
                });
              },
            );
          }),
          8.h,
        ],
      ),
    );
  }
}
