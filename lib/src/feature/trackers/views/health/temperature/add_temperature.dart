import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddTemperature extends StatelessWidget {
  final TemperatureStore? store;
  const AddTemperature({super.key, this.store});

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AddTemperatureViewStore(
            store: store, restClient: context.read<Dependencies>().restClient),
        builder: (context, child) => _Body(
              store: store,
              addTemperatureViewStore: context.watch(),
            ));
  }
}

class _Body extends StatefulWidget {
  const _Body({
    this.store,
    this.addTemperatureViewStore,
  });

  final TemperatureStore? store;
  final AddTemperatureViewStore? addTemperatureViewStore;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final AddNoteStore noteStore = context.watch<AddNoteStore>();

    return Scaffold(
      backgroundColor: AppColors.e8ddf9,
      appBar: CustomAppBar(
        title: t.trackers.temperature.add,
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
            min: 35,
            max: 42,
            step: 0.1,
            initial: 36.6,
            value: widget.addTemperatureViewStore?.temperature ?? 0,
            labelStep: 10,
            unit: '°С',
            onChanged: (v) {
              widget.addTemperatureViewStore?.updateTemperature(v);
              setState(() {});
            },
          ),
          8.h,
          CustomBlog(
            value: widget.addTemperatureViewStore?.temperatureRaw ?? '',
            onChangedValue: (v) {
              widget.addTemperatureViewStore?.updateTemperatureRaw(v);
              setState(() {});
            },
            onChangedTime: widget.addTemperatureViewStore?.updateDateTime,
            onPressedElevated: () {
              widget.addTemperatureViewStore
                  ?.add(userStore.selectedChild!.id!, noteStore.content)
                  .then((v) {
                if (context.mounted) {
                  context.pop();
                }
              });
            },
          ),
          8.h,
        ],
      ),
    );
  }
}
