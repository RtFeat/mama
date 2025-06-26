import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/diapers/diapers_dao_impl.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart' as skit;

class DiapersView extends StatelessWidget {
  const DiapersView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO нужно учесть utc время и переход на следующий день - где-то в slots.dart есть реализация.
    // TODO Нужно
    return MultiProvider(
        providers: [
          Provider(
              create: (context) => DiapersDataSourceLocal(
                  sharedPreferences:
                      context.read<Dependencies>().sharedPreferences)),
          Provider(
            create: (context) => DiapersStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              onLoad: () => context.read<DiapersDataSourceLocal>().getIsShow(),
              onSet: (value) =>
                  context.read<DiapersDataSourceLocal>().setShow(value),
            ),
          ),
        ],
        builder: (context, _) {
          final UserStore userStore = context.watch<UserStore>();
          return _Body(
            store: context.watch(),
            childId: userStore.selectedChild?.id ?? '',
          );
        });
  }
}

class _Body extends StatefulWidget {
  final DiapersStore store;
  final String childId;
  const _Body({
    required this.store,
    required this.childId,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      skit.SkitFilter(
          field: 'child_id',
          operator: skit.FilterOperator.equals,
          value: widget.childId),
      skit.SkitFilter(
          field: 'from_time',
          operator: skit.FilterOperator.equals,
          value: widget.store.startOfWeek.toUtc().toIso8601String()),
      skit.SkitFilter(
          field: 'to_time',
          operator: skit.FilterOperator.equals,
          value: widget.store.endOfWeek.toUtc().toIso8601String())
    ]
        //   queryParams: {
        //   'child_id': widget.childId,
        //   'from_time': widget.store.startOfWeek.toUtc().toIso8601String(),
        //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
        // }
        );

    widget.store.getIsShowInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return TrackerBody(
        learnMoreStore: widget.store,
        learnMoreWidgetText: t.trackers.findOutMoreTextDiapers,
        isShowLearnMore: widget.store.isShowInfo,
        onPressClose: () {
          widget.store.setIsShowInfo(false);
        },
        onPressLearnMore: () {},
        appBar: CustomAppBar(
          appBarColor: AppColors.deeperAppBarColor,
          title: t.trackers.trackersName.diapers,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          action: const ProfileWidget(),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: AppColors.trackerColor, fontSize: 20),
        ),
        bottomNavigatorBar: ButtonsLearnPdfAdd(
          onTapLearnMore: () {
            // TODO change url
            context.pushNamed(AppViews.webView, extra: {
              'url': 'https://google.com',
            });
          },
          onTapPDF: () {},
          onTapAdd: () {
            context.pushNamed(AppViews.addDiaper);
          },
          iconAddButton: AppIcons.diaperFill,
        ),
        children: [
          SliverToBoxAdapter(child: 20.h),
          SliverToBoxAdapter(
            child: DateRangeSelectorWidget(
              startDate: widget.store.startOfWeek,
              subtitle: t.trackers.diaper
                  .averageCount(n: widget.store.averageOfDiapers),
              onLeftTap: () {
                widget.store.resetPagination();
                widget.store.setSelectedDate(
                    widget.store.startOfWeek.subtract(const Duration(days: 7)));
                widget.store.loadPage(newFilters: [
                  skit.SkitFilter(
                      field: 'child_id',
                      operator: skit.FilterOperator.equals,
                      value: widget.childId),
                  skit.SkitFilter(
                      field: 'from_time',
                      operator: skit.FilterOperator.greaterThan,
                      value:
                          widget.store.startOfWeek.toUtc().toIso8601String()),
                  skit.SkitFilter(
                      field: 'to_time',
                      operator: skit.FilterOperator.lessThan,
                      value: widget.store.endOfWeek.toUtc().toIso8601String()),
                ]
                    //   queryParams: {
                    //   'child_id': widget.childId,
                    //   'from_time': widget.store.startOfWeek
                    //     ..toUtc().toIso8601String(),
                    //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
                    // }
                    );
              },
              onRightTap: () {
                widget.store.resetPagination();
                widget.store.setSelectedDate(
                    widget.store.startOfWeek.add(const Duration(days: 7)));
                widget.store.loadPage(
                  newFilters: [
                    skit.SkitFilter(
                        field: 'child_id',
                        operator: skit.FilterOperator.equals,
                        value: widget.childId),
                    skit.SkitFilter(
                        field: 'from_time',
                        operator: skit.FilterOperator.greaterThan,
                        value:
                            widget.store.startOfWeek.toUtc().toIso8601String()),
                    skit.SkitFilter(
                        field: 'to_time',
                        operator: skit.FilterOperator.lessThan,
                        value:
                            widget.store.endOfWeek.toUtc().toIso8601String()),
                  ],
                  //   queryParams: {
                  //   'child_id': widget.childId,
                  //   'from_time': widget.store.startOfWeek
                  //     ..toUtc().toIso8601String(),
                  //   'to_time': widget.store.endOfWeek.toUtc().toIso8601String()
                  // }
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: 10.h),
          skit.PaginatedLoadingWidget(
            store: widget.store,
            isFewLists: true,
            itemBuilder: (context, item, index) {
              final EntityDiapersMain diapersMain = item as EntityDiapersMain;

              return BuildDaySection(
                  date: diapersMain.data,
                  // date: diapersMain.data ?? '$index',
                  items: diapersMain.diapersSub?.map((e) {
                    final dateTime = DateTime.utc(
                      0,
                      0,
                      0,
                      int.parse(e.time!.split(':')[0]),
                      int.parse(e.time!.split(':')[1]),
                    ).toLocal();

                    return BuildGridItem(
                      time: dateTime.formattedTime,
                      title: e.typeOfDiapers ?? '',
                      // type: switch (e.typeOfDiapers) {
                      //   ''
                      // },
                      // type: e.typeOfDiapers ?? '',
                      type: TypeOfDiapers.dirty,
                      description: e.howMuch ?? '',
                      // AppColors.purpleLighterBackgroundColor,
                      // AppColors.primaryColor,
                    );
                  }).toList());
            },
          ),
        ],
      );
    });
  }
}
