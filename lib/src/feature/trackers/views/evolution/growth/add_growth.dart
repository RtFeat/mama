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
    return Provider(
        create: (context) => AddGrowthViewStore(
            // store: store,
            restClient: context.read<Dependencies>().restClient),
        builder: (context, child) => _Body(
              // store: store,
              addGrowthViewStore: context.watch(),
            ));
  }
}

class _Body extends StatefulWidget {
  const _Body({
    // this.store,
    this.addGrowthViewStore,
  });

  // final GrowthViewStore? store;
  final AddGrowthViewStore? addGrowthViewStore;

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
        title: t.trackers.growth.add,
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
            initial: widget.addGrowthViewStore?.growth.toDouble() ?? 0,
            value: widget.addGrowthViewStore?.growth.toDouble() ?? 0.0,
            labelStep: 10,
            unit: t.trackers.cm.title,
            onChanged: (v) {
              widget.addGrowthViewStore?.updateGrowth(v);
              setState(() {});
            },
          ),
          8.h,
          Observer(builder: (context) {
            return CustomBlog(
              measure: UnitMeasures.height,
              value: widget.addGrowthViewStore?.growthValue ?? '',
              onChangedValue: (v) {
                widget.addGrowthViewStore?.updateGrowthRaw(v);
                setState(() {});
              },
              onChangedTime: widget.addGrowthViewStore?.updateDateTime,
              onPressedElevated: () {
                widget.addGrowthViewStore
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
