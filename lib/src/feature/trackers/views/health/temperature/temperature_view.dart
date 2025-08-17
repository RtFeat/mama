import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (context) => TemperatureDataSourceLocal(
                sharedPreferences:
                    context.read<Dependencies>().sharedPreferences)),
        Provider(
            create: (context) => TemperatureInfoStore(
                onLoad: () =>
                    context.read<TemperatureDataSourceLocal>().getIsShow(),
                onSet: (value) =>
                    context.read<TemperatureDataSourceLocal>().setShow(value))),
        Provider(
          create: (context) {
            return TemperatureStore(
                // // onLoad: () =>
                //     context.read<TemperatureDataSourceLocal>().getIsShow(),
                // onSet: (value) =>
                //     context.read<TemperatureDataSourceLocal>().setShow(value),
                apiClient: context.read<Dependencies>().apiClient,
                faker: context.read<Dependencies>().faker);
          },
        ),
      ],
      builder: (context, child) {
        final TemperatureStore store = context.watch();
        final TemperatureInfoStore infoStore = context.watch();
        final UserStore userStore = context.watch<UserStore>();

        return _Body(
            infoStore: infoStore,
            store: store,
            childId: userStore.selectedChild?.id ?? '');
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.infoStore,
    required this.childId,
  });
  final String childId;
  final TemperatureStore store;
  final TemperatureInfoStore infoStore;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: widget.childId),
    ]);
    widget.infoStore.getIsShowInfo().then((v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextTemp,
      isShowInfo: widget.infoStore.isShowInfo,
      setIsShowInfo: (v) {
        widget.infoStore.setIsShowInfo(v).then((v) {
          setState(() {});
        });
      },
      onPressLearnMore: () {},
      stackWidget:

          /// #bottom buttons
          Align(
        alignment: Alignment.bottomCenter,
        child: ButtonsLearnPdfAdd(
          onTapLearnMore: () {},
          onTapPDF: () {},
          onTapAdd: () {
            context.pushNamed(AppViews.trackersHealthAddMedicineView, extra: {
              'store': widget.store,
            });
          },
          iconAddButton: AppIcons.thermometer,
          addButtonTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17,
              ),
        ),
      ),
      children: [
        SliverToBoxAdapter(child: 14.h),

        /// #actual table
        SliverToBoxAdapter(
            child: TemperatureHistory(
          store: context.watch(),
        )),
      ],
    );
  }
}
